import React, { useState } from 'react';
import { poolManager } from '../declarations/poolManager';
import './buy-tokens.css';

function BuyTokens() {
  const [amount, setAmount] = useState('');
  const [errorMessage, setErrorMessage] = useState('');
  const [successMessage, setSuccessMessage] = useState('');

  const handleBuy = async () => {
    try {
      if (!amount) {
        setErrorMessage('Please enter an amount');
        return;
      }

      const result = await poolManager.buyTokens(BigInt(amount));
      if ('ok' in result) {
        setSuccessMessage('Tokens purchased successfully!');
        setAmount('');
      } else {
        setErrorMessage(result.err);
      }
    } catch (error) {
      console.error('Error buying tokens:', error);
      setErrorMessage('An unexpected error occurred');
    }
  };

  return (
    <div className="container">
      <div className="buy-tokens-container">
        <h2 className="buy-tokens-header">Buy Tokens</h2>
        <form onSubmit={(e) => e.preventDefault()}>
          <div className="mb-3">
            <label htmlFor="tokenAmount" className="buy-tokens-label">Amount of tokens:</label>
            <input 
              type="number" 
              className="form-control buy-tokens-input amount-input"
              id="tokenAmount"
              value={amount} 
              onChange={(e) => setAmount(e.target.value)} 
              placeholder="Enter amount of tokens"
            />
          </div>
          {errorMessage && <p className="error-message">{errorMessage}</p>}
          {successMessage && <p className="success-message">{successMessage}</p>}
          <button 
            type="submit" 
            className="btn btn-primary buy-tokens-button"
            onClick={handleBuy}
          >
            Buy Tokens
          </button>
        </form>
      </div>
    </div>
  );
}

export default BuyTokens;
