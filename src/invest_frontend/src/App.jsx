import React, { useState, useEffect } from 'react';
import { invest_backend } from '../../declarations/invest_backend';
import './styles.css'; // Import the stylesheet

function App() {
  const [totalTokens, setTotalTokens] = useState(0);
  const [tokenPrice, setTokenPrice] = useState(1000000); // Initial price in e8s (ICPs smallest unit)
  const [userBalance, setUserBalance] = useState(0);
  const [insuranceFundBalance, setInsuranceFundBalance] = useState(0);

  const [investmentStrategies, setInvestmentStrategies] = useState([]);
  const [insuranceHistory, setInsuranceHistory] = useState({});

  // Function to fetch data from the smart contract
  async function fetchData() {
    try {
      // Get token price
      const price = await invest_backend.getTokenPrice();
      setTokenPrice(Number(price));

      // Get user balance
      const balance = await invest_backend.getUserBalance(principal);
      setUserBalance(Number(balance));

      // Get insurance fund balance
      const fundBalance = await invest_backend.getInsuranceFundBalance();
      setInsuranceFundBalance(Number(fundBalance));

      // Get investment strategies
      const strategies = await invest_backend.getInvestmentStrategies();
      setInvestmentStrategies(strategies);

      // Get user insurance history
      const userHistory = await invest_backend.getUserInsuranceHistory(principal);
      setInsuranceHistory({ [principal]: userHistory });
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  }

  useEffect(() => {
    fetchData();
  }, []);

  // Function to handle buying tokens
  const handleBuyTokens = async (e) => {
    e.preventDefault();

    // Get the amount to buy
    const amount = BigInt(e.target.amount.value);

    try {
      // Call invest_backend.buyTokens
      const result = await invest_backend.buyTokens(amount);

      if ('ok' in result) {
        alert('Tokens purchased successfully!');
        fetchData(); // Update data after successful purchase
      } else {
        alert(`Error: ${result.err}`);
      }
    } catch (error) {
      console.error('Error buying tokens:', error);
    }
  };

  // Function to handle investments
  const handleInvest = async (e) => {
    e.preventDefault();

    // Get the investment amount and strategy name
    const amount = BigInt(e.target.amount.value);
    const strategyName = e.target.strategyName.value;

    try {
      // Call invest_backend.invest
      const result = await invest_backend.invest(amount, strategyName);

      if ('ok' in result) {
        alert('Investment successful!');
        fetchData(); // Update data after successful investment
      } else {
        alert(`Error: ${result.err}`);
      }
    } catch (error) {
      console.error('Error investing:', error);
    }
  };

  // Function to handle acquiring insurance
  const handleAcquireInsurance = async (e) => {
    e.preventDefault();

    // Get the coverage amount
    const coverageAmount = BigInt(e.target.coverageAmount.value);

    try {
      // Call invest_backend.acquireInsurance
      await invest_backend.acquireInsurance(coverageAmount);

      alert('Insurance acquired successfully!');
      fetchData(); // Update data after successful insurance acquisition
    } catch (error) {
      console.error('Error acquiring insurance:', error);
      alert(`Error: ${error}`);
    }
  };

  return (
    <div className="app">
      <h1>Pool Manager Dashboard</h1>

      <div className="token-info">
        <h2>Total Tokens: {totalTokens}</h2>
        <h2>Token Price: ${Number(tokenPrice).toFixed(2)}</h2>
      </div>

      <div className="balance-info">
        <h2>Your Balance: ${Number(userBalance).toFixed(2)}</h2>
      </div>

      <div className="insurance-info">
        <h2>Insurance Fund Balance: ${Number(insuranceFundBalance).toFixed(2)}</h2>
      </div>

      <h2>Investment Strategies</h2>
      <ul>
        {investmentStrategies.map((strategy) => (
          <li key={strategy.name}>
            <strong>{strategy.name}:</strong>
            <p>Risk Level: {strategy.riskLevel.toFixed(2)}</p>
            <p>Description: {strategy.description}</p>
            <p>Current Value: {strategy.currentValue.toString()}</p>
          </li>
        ))}
      </ul>

      <h2>Actions</h2>
      <form onSubmit={handleBuyTokens}>
        <input type="number" name="amount" placeholder="Amount to buy" required />
        <button type="submit">Buy Tokens</button>
      </form>

      <form onSubmit={handleInvest}>
        <select name="strategyName" required>
          {investmentStrategies.map(strategy => (
            <option key={strategy.name} value={strategy.name}>{strategy.name}</option>
          ))}
        </select>
        <input type="number" name="amount" placeholder="Amount to invest" required />
        <button type="submit">Invest</button>
      </form>

      <form onSubmit={handleAcquireInsurance}>
        <input type="number" name="coverageAmount" placeholder="Coverage Amount" required />
        <button type="submit">Acquire Insurance</button>
      </form>
    </div>
  );
}

export default App;
