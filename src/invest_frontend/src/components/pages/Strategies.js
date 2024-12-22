import React, { useState, useEffect } from 'react';
import { poolManager } from '../declarations/poolManager';
import './strategies.css';

function Strategies() {
  const [strategies, setStrategies] = useState([]);

  useEffect(() => {
    async function fetchStrategies() {
      const strategyList = await poolManager.getInvestmentStrategies();
      setStrategies(strategyList);
    }
    fetchStrategies();
  }, []);

  return (
    <div className="container">
      <div className="strategies-container">
        <h2 className="strategies-header">Investment Strategies</h2>
        <ul className="strategies-list">
          {strategies.map((strategy) => (
            <li key={strategy.name} className="strategy-item">
              <h3 className="strategy-name">{strategy.name}</h3>
              <p className="strategy-description">Description: {strategy.description}</p>
              <p className="risk-level">Risk Level: {strategy.riskLevel}</p>
              <p className="current-value">Current Value: {strategy.currentValue.toString()}</p>
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}

export default Strategies;
