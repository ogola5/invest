import React, { useState, useEffect } from 'react';
import { poolManager } from '../declarations/poolManager';
import './invest.css';

function Invest() {
  const [amount, setAmount] = useState('');
  const [strategy, setStrategy] = useState('');
  const [strategies, setStrategies] = useState([]);

  useEffect(() => {
    async function fetchStrategies() {
      const strategyList = await poolManager.getInvestmentStrategies();
      setStrategies(strategyList);
    }
    fetchStrategies();
  }, []);

  const handleInvest = async () => {
    try {
      if (!amount || !strategy) {
        alert('Please fill in both amount and strategy');
        return;
      }

      const result = await poolManager.invest(BigInt(amount), strategy);
      if ('ok' in result) {
        alert('Investment successful!');
        setAmount('');
        setStrategy('');
      } else {
        alert(`Error: ${result.err}`);
      }
    } catch (error) {
      console.error('Error investing:', error);
      alert('An unexpected error occurred');
    }
  };

  return (
    <div className="container">
        <div className="invest-container">
            <h2 className="invest-header">Invest</h2>
            <form onSubmit={(e) => e.preventDefault()}>
            <div className="mb-3">
                <label htmlFor="investmentAmount" className="invest-label">Amount to invest:</label>
                <input 
                type="number" 
                className="form-control invest-input"
                id="investmentAmount"
                value={amount} 
                onChange={(e) => setAmount(e.target.value)} 
                placeholder="Enter amount"
                />
            </div>
            <div className="mb-3">
                <label htmlFor="strategySelect" className="invest-label">Strategy:</label>
                <select 
                className="form-select invest-select"
                id="strategySelect"
                value={strategy} 
                onChange={(e) => setStrategy(e.target.value)}
                >
                <option value="">Select a strategy</option>
                {strategies.map((s) => (
                    <option key={s.name} value={s.name}>{s.name}</option>
                ))}
                </select>
            </div>
            <button 
                type="submit" 
                className="btn btn-primary invest-button"
                onClick={handleInvest}
            >
                Invest
            </button>
            </form>
        </div>
    </div>
  );
}

export default Invest;
