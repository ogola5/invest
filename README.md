# PoolManager App

## Overview

The **PoolManager App** is a decentralized application (dApp) built on the Internet Computer Protocol (ICP) that provides an investment and insurance platform. Users can purchase tokens, invest in predefined strategies, and acquire insurance coverage. The app also includes advanced features such as rebalancing investments, auditing user history, and simulating investment performance.

## Features

### Token Management
- **Buy Tokens:** Users can purchase tokens to participate in investments or pay for insurance premiums.
- **Withdraw Tokens:** Users can withdraw their tokens from the platform.

### Investment Strategies
- **Add Investment Strategy:** Administrators can define new investment strategies with a name, description, and risk level.
- **Invest Tokens:** Users can allocate their tokens to specific investment strategies.
- **Rebalance Investments:** Users can redistribute their tokens among multiple investment strategies.
- **Simulate Strategy Performance:** Simulate the performance of an investment strategy by applying a percentage change.

### Insurance Management
- **Acquire Insurance:** Users can purchase insurance coverage with a premium calculated as 5% of the coverage amount.
- **Cancel Insurance:** Users can cancel their insurance policy and receive a 50% refund of the premium paid.
- **Track Insurance History:** Each user's insurance acquisitions are recorded for tracking.

### Query Functions
- **Get Token Price:** Retrieve the current price of tokens.
- **Get Investment Strategies:** View all available investment strategies.
- **Get User Balance:** Check a user's token balance.
- **Get Insurance Fund Balance:** View the total funds allocated to insurance.
- **Get User Insurance History:** Retrieve the insurance history for a user.
- **Audit User History:** View a detailed audit of a user's transactions and activities.

## Data Structures

### Investment Strategy
```motoko
public type InvestmentStrategy = {
  name: Text;
  description: Text;
  riskLevel: Float; // Risk level (0.0 to 1.0)
  currentValue: Nat64; // Current value of the strategy
};
### User Records
Investments: Tracks each user's token balance.
Insurance History: Records each user's insurance acquisitions.
Investment Strategies: Stores all available investment strategies.
Technical Details
Programming Language
The application is written in Motoko, a programming language specifically designed for the Internet Computer Protocol.

Dependencies
The project uses several Motoko base libraries:

Principal for user identity management.
HashMap for efficient data storage and retrieval.
Result for error handling.
Debug for logging and debugging.
Float, Nat64, Int, and Int64 for mathematical operations.
Token Simulations
The app currently uses a simulated token transfer logic for the MVP. Full integration with a token standard (e.g., ICRC-1) can be implemented in future updates.

Usage
Buying Tokens
motoko
Copy code
public shared(msg) func buyTokens(amount: Nat64): async Result.Result<Text, Text>
Users can purchase tokens by specifying the amount. The cost is calculated as amount * tokenPrice.

### Adding an Investment Strategy
motoko
Copy code
public shared func addInvestmentStrategy(name: Text, description: Text, riskLevel: Float): async Result.Result<Text, Text>
Admins can add a new investment strategy with a specific name, description, and risk level.

Acquiring Insurance
motoko
Copy code
public shared(msg) func acquireInsurance(coverageAmount: Nat64): async Result.Result<(), Text>
Users can acquire insurance coverage by paying a premium of 5% of the coverage amount.

Future Enhancements
Integration with ICRC-1 token standard.
User interface for better accessibility.
Enhanced analytics for investment strategies.
Multi-currency support.
Installation
Clone the repository:

bash
Copy code
git clone https://github.com/ogola5/invest.git
cd invest
Deploy the canister:

dfx start --background --clean
dfx deploy
Interact with the canister using the provided API.

Contributing
Contributions are welcome! Please fork the repository, make your changes, and submit a pull request.

