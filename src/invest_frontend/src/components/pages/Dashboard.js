import React, { useState, useEffect } from 'react';
import { poolManager } from '../declarations/poolManager';
import './dashboard.css';

function Dashboard() {
  const [tokenPrice, setTokenPrice] = useState(0);
  const [userBalance, setUserBalance] = useState(0);
  const [insuranceFundBalance, setInsuranceFundBalance] = useState(0);

  useEffect(() => {
    async function fetchData() {
      try {
        const price = await poolManager.getTokenPrice();
        setTokenPrice(Number(price));

        // Note: You'll need to implement a way to get the user's principal
        const balance = await poolManager.getUserBalance(/* user principal */);
        setUserBalance(Number(balance));

        const fundBalance = await poolManager.getInsuranceFundBalance();
        setInsuranceFundBalance(Number(fundBalance));
      } catch (error) {
        console.error('Error fetching data:', error);
      }
    }
    fetchData();
  }, []);

  return (
    <div className="container">
      <header className="header">
        <h1>Dashboard</h1>
      </header>

      <div className="dashboard-content">
        <div className="card token-price">
          <h2>Token Price</h2>
          <p>{tokenPrice}</p>
        </div>

        <div className="card user-balance">
          <h2>Your Balance</h2>
          <p>{userBalance}</p>
        </div>

        <div className="card insurance-fund">
          <h2>Insurance Fund Balance</h2>
          <p>{insuranceFundBalance}</p>
        </div>
      </div>
    </div>
  );
}

export default Dashboard;