import React, { useState } from 'react';
import { poolManager } from '../declarations/poolManager';
import './add-strategy.css';

function AddStrategy() {
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const [riskLevel, setRiskLevel] = useState('');
  const [errorMessage, setErrorMessage] = useState('');
  const [successMessage, setSuccessMessage] = useState('');

  const handleAdd = async () => {
    try {
      if (!name || !description || !riskLevel) {
        setErrorMessage('Please fill in all fields');
        return;
      }

      const result = await poolManager.addInvestmentStrategy(name, description, parseFloat(riskLevel));
      if ('ok' in result) {
        setSuccessMessage('Strategy added successfully!');
        setName('');
        setDescription('');
        setRiskLevel('');
      } else {
        setErrorMessage(result.err);
      }
    } catch (error) {
      console.error('Error adding strategy:', error);
      setErrorMessage('An unexpected error occurred');
    }
  };

  return (
    <div className="container">
      <div className="add-strategy-container">
        <h2 className="add-strategy-header">Add Investment Strategy</h2>
        <form onSubmit={(e) => e.preventDefault()}>
          <div className="mb-3">
            <label htmlFor="strategyName" className="add-strategy-label">Strategy Name:</label>
            <input 
              type="text" 
              className="form-control add-strategy-input"
              id="strategyName"
              value={name} 
              onChange={(e) => setName(e.target.value)} 
              placeholder="Enter strategy name"
            />
          </div>
          <div className="mb-3">
            <label htmlFor="strategyDescription" className="add-strategy-label">Strategy Description:</label>
            <textarea 
              rows="4" 
              className="form-control add-strategy-input"
              id="strategyDescription"
              value={description} 
              onChange={(e) => setDescription(e.target.value)} 
              placeholder="Enter strategy description"
            ></textarea>
          </div>
          <div className="mb-3">
            <label htmlFor="riskLevel" className="add-strategy-label">Risk Level (0.0 - 1.0):</label>
            <input 
              type="number" 
              className="form-control add-strategy-input risk-level-input"
              id="riskLevel"
              value={riskLevel} 
              onChange={(e) => setRiskLevel(e.target.value)} 
              placeholder="Enter risk level"
              step="0.1"
              min="0"
              max="1"
            />
          </div>
          {errorMessage && <p className="error-message">{errorMessage}</p>}
          {successMessage && <p className="success-message">{successMessage}</p>}
          <button 
            type="submit" 
            className="btn btn-primary add-strategy-button"
            onClick={handleAdd}
          >
            Add Strategy
          </button>
        </form>
      </div>
    </div>
  );
}

export default AddStrategy;
