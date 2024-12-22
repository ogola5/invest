import React, { useState } from 'react';
import { poolManager } from '../declarations/poolManager';
import './acquire-insurance.css';

function AcquireInsurance() {
  const [coverageAmount, setCoverageAmount] = useState('');

  const handleAcquire = async () => {
    try {
      const result = await poolManager.acquireInsurance(BigInt(coverageAmount));
      if ('ok' in result) {
        alert('Insurance acquired successfully!');
      } else {
        alert(`Error: ${result.err}`);
      }
    } catch (error) {
      console.error('Error acquiring insurance:', error);
    }
  };

  return (
    <div className="container mt-5">
      <div className="card acquire-insurance-card">
        <div className="card-body">
          <h2>Acquire Insurance</h2>
          <form onSubmit={(e) => e.preventDefault()}>
            <input
              type="number"
              className="form-control acquire-insurance-input"
              value={coverageAmount}
              onChange={(e) => setCoverageAmount(e.target.value)}
              placeholder="Enter coverage amount"
            />
            <button
              type="submit"
              className="btn btn-primary acquire-insurance-button"
              onClick={handleAcquire}
            >
              Acquire Insurance
            </button>
          </form>
        </div>
      </div>
    </div>
  );
}

export default AcquireInsurance;