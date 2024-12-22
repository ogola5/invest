// import Principal "mo:base/Principal";
// import Nat64 "mo:base/Nat64";
// import Float "mo:base/Float";
// import Debug "mo:base/Debug";
// import HashMap "mo:base/HashMap";
// import Text "mo:base/Text";
// import Result "mo:base/Result";
// import Iter "mo:base/Iter";

// actor PoolManager {
//   var totalTokens : Nat64 = 0;
//   var tokenPrice : Nat64 = 1_000_000; // Initial price in e8s
//   let investments = HashMap.HashMap<Principal, Nat64>(32, Principal.equal, Principal.hash);
//   var insuranceFund : Nat64 = 0;

//   public type InvestmentStrategy = {
//     name : Text;
//     description : Text;
//     riskLevel : Float;
//     currentValue : Nat64;
//   };

//   let investmentStrategies = HashMap.HashMap<Text, InvestmentStrategy>(32, Text.equal, Text.hash);

//   public query func getTokenPrice() : async Nat64 {
//     tokenPrice
//   };

//   public shared(msg) func buyTokens(amount : Nat64) : async Result.Result<(), Text> {
//     // let cost = amount * tokenPrice;
//     Debug.print("User " # Principal.toText(msg.caller) # " is buying " # Nat64.toText(amount) # " tokens");
    
//     // TODO: Implement ICRC-1 token transfer here
//     // This is a placeholder for the actual token transfer logic
    
//     totalTokens += amount;
//     let newBalance = switch (investments.get(msg.caller)) {
//       case (null) { amount };
//       case (?balance) { balance + amount };
//     };
//     investments.put(msg.caller, newBalance);
    
//     Debug.print("Token purchase successful. New balance: " # Nat64.toText(newBalance));
//     #ok()
//   };

//   public shared(msg) func invest(amount : Nat64, strategyName : Text) : async Result.Result<(), Text> {
//     let balance = switch (investments.get(msg.caller)) {
//       case (null) { return #err("No investment found for user"); };
//       case (?bal) { bal };
//     };
    
//     if (balance < amount) {
//       return #err("Insufficient balance");
//     };

//     switch(investmentStrategies.get(strategyName)) {
//       case (?strategy) {
//         // Update investment records
//         investments.put(msg.caller, balance - amount);
        
//         // Create a new strategy object with updated value
//         let updatedStrategy : InvestmentStrategy = {
//           name = strategy.name;
//           description = strategy.description;
//           riskLevel = strategy.riskLevel;
//           currentValue = strategy.currentValue + amount;
//         };
//         investmentStrategies.put(strategyName, updatedStrategy);
        
//         Debug.print("Investment successful. Strategy value updated: " # Nat64.toText(updatedStrategy.currentValue));
//         #ok()
//       };
//       case (_) {
//         #err("Invalid investment strategy")
//       }
//     }
//   };

//   public shared(msg) func acquireInsurance(coverageAmount : Nat64) : async Result.Result<(), Text> {
//     let premium = calculatePremium(coverageAmount);
//     let balance = switch (investments.get(msg.caller)) {
//       case (null) { return #err("No investment found for user"); };
//       case (?bal) { bal };
//     };
    
//     if (balance < premium) {
//       return #err("Insufficient balance for insurance premium");
//     };
    
//     Debug.print("User " # Principal.toText(msg.caller) # " is acquiring insurance coverage of " # Nat64.toText(coverageAmount));
    
//     insuranceFund += premium;
//     investments.put(msg.caller, balance - premium);
    
//     Debug.print("Insurance acquired. New insurance fund balance: " # Nat64.toText(insuranceFund));
//     #ok()
//   };

//   public shared func addInvestmentStrategy(name : Text, description : Text, riskLevel : Float) : async Result.Result<(), Text> {
//     if (riskLevel < 0.0 or riskLevel > 1.0) {
//       return #err("Risk level must be between 0.0 and 1.0");
//     };
    
//     let strategy : InvestmentStrategy = {
//       name = name;
//       description = description;
//       riskLevel = riskLevel;
//       currentValue = 0;
//     };
//     investmentStrategies.put(name, strategy);
//     Debug.print("New investment strategy added: '" # name # "'");
//     #ok()
//   };

//   private func calculatePremium(coverageAmount : Nat64) : Nat64 {
//     // Simulated premium calculation based on coverage amount
//     coverageAmount * 50_000 // 5% of coverage amount
//   };

//   public query func getInvestmentStrategies() : async [InvestmentStrategy] {
//     Iter.toArray(
//       Iter.map(
//         investmentStrategies.vals(),
//         func (strategy : InvestmentStrategy) : InvestmentStrategy { strategy }
//       )
//     )
//   };

//   public query func getUserBalance(user : Principal) : async Nat64 {
//     switch (investments.get(user)) {
//       case (null) { 0 };
//       case (?balance) { balance };
//     }
//   };

//   public query func getInsuranceFundBalance() : async Nat64 {
//     insuranceFund
//   };
// };
import Principal "mo:base/Principal";
import Nat64 "mo:base/Nat64";
import Float "mo:base/Float";
import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Result "mo:base/Result";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Int "mo:base/Int";
import Int64 "mo:base/Int64";


actor PoolManager {
  var totalTokens: Nat64 = 0;
  var tokenPrice: Nat64 = 1_000_000; // Initial price in e8s (ICPs smallest unit)
  let investments = HashMap.HashMap<Principal, Nat64>(32, Principal.equal, Principal.hash);
  
  var insuranceFund: Nat64 = 0;

  public type InvestmentStrategy = {
    name: Text;
    description: Text;
    riskLevel: Float;
    currentValue: Nat64;
  };

  let investmentStrategies = HashMap.HashMap<Text, InvestmentStrategy>(32, Text.equal, Text.hash);

  // Mocking a record of insurance acquisitions for tracking
  let insuranceHistory = HashMap.HashMap<Principal, [Nat64]>(32, Principal.equal, Principal.hash);

  public query func getTokenPrice(): async Nat64 {
    tokenPrice
  };

  // Simulate token transfer logic (ICRC-1 placeholder)
  private func simulateTokenTransfer(user: Principal, amount: Nat64): Bool {
    Debug.print("Simulating token transfer of " # Nat64.toText(amount) # " for user " # Principal.toText(user));
    true // Always succeeds for MVP mock
  };

  public shared(msg) func buyTokens(amount: Nat64): async Result.Result<Text, Text> {
    let cost = amount * tokenPrice;
    Debug.print("User " # Principal.toText(msg.caller) # " attempting to buy " # Nat64.toText(amount) # " tokens for " # Nat64.toText(cost) # " e8s");

    if (not simulateTokenTransfer(msg.caller, cost)) {
      return #err("Token transfer failed.");
    };

    totalTokens += amount;
    let newBalance = switch (investments.get(msg.caller)) {
      case (null) { amount };
      case (?balance) { balance + amount };
    };
    investments.put(msg.caller, newBalance);

    Debug.print("Token purchase successful. User balance updated to " # Nat64.toText(newBalance));
    #ok("Purchased " # Nat64.toText(amount) # " tokens successfully.")
  };

  public shared(msg) func invest(amount: Nat64, strategyName: Text): async Result.Result<Text, Text> {
    let balance = switch (investments.get(msg.caller)) {
      case (null) { return #err("No tokens available for investment."); };
      case (?bal) { bal };
    };

    if (balance < amount) {
      return #err("Insufficient token balance to invest.");
    };

    switch (investmentStrategies.get(strategyName)) {
      case (?strategy) {
        investments.put(msg.caller, balance - amount);

        let updatedStrategy: InvestmentStrategy = {
          name = strategy.name;
          description = strategy.description;
          riskLevel = strategy.riskLevel;
          currentValue = strategy.currentValue + amount;
        };
        investmentStrategies.put(strategyName, updatedStrategy);

        Debug.print("Investment successful. Strategy '" # strategyName # "' updated with new value " # Nat64.toText(updatedStrategy.currentValue));
        #ok("Invested " # Nat64.toText(amount) # " tokens in strategy '" # strategyName # "'.")
      };
      case (_) { return #err("Invalid investment strategy."); };
    }
  };

  public shared(msg) func acquireInsurance(coverageAmount: Nat64): async Result.Result<(), Text> {
      let premium = calculatePremium(coverageAmount);
      let balance = switch (investments.get(msg.caller)) {
        case (null) { return #err("No investment found for user"); };
        case (?bal) { bal };
      };
      
      if (balance < premium) {
        return #err("Insufficient balance for insurance premium");
      };
      
      Debug.print("User " # Principal.toText(msg.caller) # " is acquiring insurance coverage of " # Nat64.toText(coverageAmount));
      
      insuranceFund += premium;
      investments.put(msg.caller, balance - premium);

      // Append coverageAmount to user's insurance history
      let history = insuranceHistory.get(msg.caller);
      let updatedHistory = switch (history) {
        case (null) { [coverageAmount] }; // First insurance record
        case (?existingHistory) { Array.append(existingHistory, [coverageAmount]) };
 // Append to existing records
      };
      insuranceHistory.put(msg.caller, updatedHistory);

      Debug.print("Insurance acquired. New insurance fund balance: " # Nat64.toText(insuranceFund));
      #ok()
  };


  public shared func addInvestmentStrategy(name: Text, description: Text, riskLevel: Float): async Result.Result<Text, Text> {
    if (riskLevel < 0.0 or riskLevel > 1.0) {
      return #err("Risk level must be between 0.0 and 1.0.");
    };

    let strategy: InvestmentStrategy = {
      name = name;
      description = description;
      riskLevel = riskLevel;
      currentValue = 0;
    };
    investmentStrategies.put(name, strategy);
    Debug.print("New investment strategy added: '" # name # "'.");
    #ok("Added investment strategy: '" # name # "'.")
  };

  private func calculatePremium(coverageAmount: Nat64): Nat64 {
    coverageAmount * 5 / 100 // 5% of coverage amount
  };

  public query func getInvestmentStrategies(): async [InvestmentStrategy] {
    Iter.toArray(investmentStrategies.vals())
  };

  public query func getUserBalance(user: Principal): async Nat64 {
    switch (investments.get(user)) {
      case (null) { 0 };
      case (?balance) { balance };
    }
  };

  public query func getInsuranceFundBalance(): async Nat64 {
    insuranceFund
  };

  public query func getUserInsuranceHistory(user: Principal): async [Nat64] {
    switch (insuranceHistory.get(user)) {
      case (null) { [] };
      case (?history) { history };
    }
  };
  public shared(msg) func withdrawTokens(amount: Nat64): async Result.Result<Text, Text> {
    let balance = switch (investments.get(msg.caller)) {
      case (null) { return #err("No tokens available to withdraw."); };
      case (?bal) { bal };
    };

    if (balance < amount) {
      return #err("Insufficient token balance.");
    };

    investments.put(msg.caller, balance - amount);
    totalTokens -= amount;

    Debug.print("User " # Principal.toText(msg.caller) # " withdrew " # Nat64.toText(amount) # " tokens.");
    #ok("Successfully withdrew " # Nat64.toText(amount) # " tokens.")
  };
  public shared(msg) func cancelInsurance(): async Result.Result<Text, Text> {
    let history = switch (insuranceHistory.get(msg.caller)) {
      case (null) { return #err("No active insurance policy found."); };
      case (?h) { h };
    };

    if (history.size() == 0) {
      return #err("No insurance policies to cancel.");
    };

    let lastCoverageAmount : Nat64 = switch (history.size()) {
      case 0 { return #err("No insurance policies to cancel.") };
      case size { history[size - 1] };
    };

    let refund : Nat64 = lastCoverageAmount * 50 / 100; // Refund 50% of the last premium
    let updatedHistory = Array.tabulate<Nat64>(history.size() - 1, func(i) { history[i] });

    insuranceFund -= refund;
    let balance = switch (investments.get(msg.caller)) {
      case (null) { refund };
      case (?bal) { bal + refund };
    };

    investments.put(msg.caller, balance);
    insuranceHistory.put(msg.caller, updatedHistory);

    Debug.print("User " # Principal.toText(msg.caller) # " canceled their insurance policy. Refund: " # Nat64.toText(refund));
    #ok("Insurance policy canceled. Refund of " # Nat64.toText(refund) # " tokens issued.")
  };
  public shared(msg) func rebalanceInvestments(newAllocations: [(Text, Nat64)]): async Result.Result<Text, Text> {
    let balance = switch (investments.get(msg.caller)) {
      case (null) { return #err("No tokens available to rebalance."); };
      case (?bal) { bal };
    };

    let totalAllocation = Array.foldLeft<Nat64, Nat64>(
      Array.map<(Text, Nat64), Nat64>(
        Iter.toArray(newAllocations.vals()), 
        func((_, amount): (Text, Nat64)): Nat64 { amount }
      ),
      0,
      func(acc, alloc) { acc + alloc }
    );


    if (totalAllocation != balance) {
      return #err("Total allocations must equal your current token balance.");
    };

    for ((strategyName, amount) in newAllocations.vals()) {
      switch (investmentStrategies.get(strategyName)) {
        case (null) { return #err("Invalid strategy: " # strategyName); };
        case (?strategy) {
          let updatedStrategy: InvestmentStrategy = {
            name = strategy.name;
            description = strategy.description;
            riskLevel = strategy.riskLevel;
            currentValue = strategy.currentValue + amount;
          };
          investmentStrategies.put(strategyName, updatedStrategy);
        };
      };
    };

    investments.put(msg.caller, 0); // All tokens reallocated
    Debug.print("Rebalanced investments for user " # Principal.toText(msg.caller));
    #ok("Rebalanced investments successfully.")
  };
  public func simulateStrategyPerformance(strategyName: Text, percentageChange: Float): async Result.Result<Text, Text> {
    switch (investmentStrategies.get(strategyName)) {
      case (null) { return #err("Strategy not found: " # strategyName); };
      case (?strategy) {
        let newValue = Nat64.fromNat(Int.abs(Int64.toInt(Float.toInt64(Float.fromInt64(Int64.fromNat64(strategy.currentValue)) * (1.0 + percentageChange / 100.0)))));

        let updatedStrategy: InvestmentStrategy = {
          name = strategy.name;
          description = strategy.description;
          riskLevel = strategy.riskLevel;
          currentValue = newValue;
        };
        investmentStrategies.put(strategyName, updatedStrategy);

        Debug.print("Simulated performance for strategy '" # strategyName # "'. New value: " # Nat64.toText(newValue));
        #ok("Strategy '" # strategyName # "' updated. Performance changed by " # Float.toText(percentageChange) # "%.")
      };
    }
  };
  public query func auditUserHistory(user: Principal): async {
    tokenBalance: Nat64;
    insurancePolicies: [Nat64];
    investments: [(Text, Nat64)];
  } {
    let tokenBalance = switch (investments.get(user)) {
      case (null) { 0 : Nat64 };
      case (?bal) { bal };
    };

    let insurancePolicies = switch (insuranceHistory.get(user)) {
      case (null) { [] };
      case (?history) { history };
    };

    let userInvestments = Iter.toArray(
      Iter.filter<(Text, InvestmentStrategy)>(
        investmentStrategies.entries(),
        func(_, strategy) { strategy.currentValue > 0 }
      )
    );

    {
      tokenBalance = tokenBalance;
      insurancePolicies = insurancePolicies;
      investments = Array.map<(Text, InvestmentStrategy), (Text, Nat64)>(
        userInvestments, 
        func((name, strategy)) {
          (name, strategy.currentValue)
        }
      );
    }
  };

};
