# ERC-4337 (Account Abstraction)

## Overview

**ERC-4337** introduces **Account Abstraction** to Ethereum without requiring changes to the Ethereum protocol.

Instead of using an **Externally Owned Account (EOA)** to directly send transactions, users interact through a **Smart Account** (a smart contract wallet). The Smart Account contains programmable authentication and authorization logic, making wallets significantly more powerful and flexible.

Unlike traditional Ethereum transactions, ERC-4337 introduces a new object called a **UserOperation**.

```
Traditional Ethereum

User
 │
 ▼
EOA
 │
 ▼
Transaction
 │
 ▼
Ethereum
 │
 ▼
Target Contract
```

```
ERC-4337

User
 │
 ▼
UserOperation
 │
 ▼
Bundler
 │
 ▼
EntryPoint
 │
 ▼
Smart Account
 │
 ▼
Target Contract
```

---

# Motivation

Traditional EOAs have several limitations:

* One private key controls everything.
* Lost key = lost wallet.
* Cannot implement multisig.
* Cannot implement social recovery.
* Cannot pay gas with ERC20 tokens.
* Cannot batch multiple operations.
* Authentication logic is fixed forever.

ERC-4337 solves these problems by moving wallet logic into a smart contract.

---

# Core Components

ERC-4337 consists of several independent components.

```
                User
                 │
                 ▼
          UserOperation
                 │
                 ▼
              Bundler
                 │
                 ▼
            EntryPoint
                 │
      validateUserOp()
                 │
                 ▼
          Smart Account
                 │
            execute()
                 │
                 ▼
            Target Contract
```

---

# UserOperation

Instead of signing a transaction, users sign a **UserOperation**.

A simplified version looks like this:

```solidity
struct UserOperation {
    address sender;
    uint256 nonce;
    address target;
    uint256 value;
    bytes data;
    bytes signature;
}
```

Unlike Ethereum transactions, this is simply a Solidity struct.

It describes **what the user wants to execute**.

---

# Smart Account

A Smart Account replaces the traditional wallet.

Instead of Ethereum validating the user's signature automatically, the Smart Account decides how authentication works.

Examples:

* ECDSA signature
* Multi-signature
* Passkeys
* Session keys
* Guardians
* Social recovery
* Spending limits

---

# EntryPoint

EntryPoint is the heart of ERC-4337.

Every UserOperation passes through it.

Responsibilities:

* Validate the operation
* Verify gas payment
* Execute the requested action
* Charge gas

Pseudo code:

```text
for each UserOperation

    validateUserOp()

    execute()

    pay gas
```

---

# Bundler

Ethereum validators understand Ethereum transactions.

They do **not** understand UserOperations.

A Bundler collects UserOperations from users and submits them as a normal Ethereum transaction.

```
Many UserOperations
        │
        ▼
     Bundler
        │
        ▼
Ethereum Transaction
```

---

# Paymaster

Normally users must own ETH.

ERC-4337 introduces the Paymaster.

```
User
 │
 ▼
Paymaster
 │
 ▼
Pays Gas
```

Possible use cases:

* Gasless onboarding
* Company-sponsored transactions
* Paying gas with ERC20
* DAO-sponsored transactions

---

# Smart Account Lifecycle

```
User signs UserOperation
          │
          ▼
EntryPoint receives request
          │
          ▼
validateUserOp()
          │
          ▼
execute()
          │
          ▼
Target Contract
```

---

# Minimal Educational Implementation

The repository contains a simplified implementation:

```
contracts/

UserOperation.sol

EntryPoint.sol

SmartAccount.sol

Counter.sol
```

The implementation removes many production details to focus on the overall architecture.

---

# Example

Suppose Alice wants to increment a counter.

Traditional Ethereum:

```
Alice

↓

Transaction

↓

Counter.increment()
```

ERC-4337:

```
Alice

↓

Sign UserOperation

↓

EntryPoint

↓

validateUserOp()

↓

execute()

↓

Counter.increment()
```

---

# Validation vs Execution

One of the most important ideas in ERC-4337 is separating **validation** from **execution**.

```
validateUserOp()

↓

Is user authorized?

↓

execute()

↓

Call destination contract
```

Because validation is programmable, developers can implement almost any authentication mechanism.

---

# Benefits

## Social Recovery

```
Guardian A

Guardian B

Guardian C

↓

2 signatures

↓

Recover wallet
```

---

## Daily Spending Limits

```solidity
if (spentToday > dailyLimit)
    revert();
```

---

## Session Keys

Perfect for games.

```
Approve once

↓

Temporary key

↓

Play without signing every action
```

---

## Batch Transactions

Traditional wallet:

```
Approve

↓

Swap

↓

Stake
```

Three transactions.

ERC-4337:

```
executeBatch()

↓

Approve

↓

Swap

↓

Stake
```

One operation.

---

## Multisignature

```solidity
require(validSignatures >= 3);
```

---

## Custom Authentication

Authentication is entirely programmable.

Examples:

* FaceID
* Fingerprint
* Hardware Security Module
* Guardian approval
* Zero Knowledge Proof
* Passkeys

---

# Repository Structure

```
erc4337/

├── README.md
├── contracts
│   ├── UserOperation.sol
│   ├── IEntryPoint.sol
│   ├── EntryPoint.sol
│   ├── SmartAccount.sol
│   └── Counter.sol
└── test
```

---

# Learning Goals

After studying this example, you should understand:

* Why ERC-4337 exists
* How Account Abstraction works
* The role of UserOperation
* Why EntryPoint exists
* Why validation and execution are separated
* How Smart Accounts replace EOAs
* How programmable wallets enable entirely new UX

---

# Simplified vs Production ERC-4337

This repository intentionally simplifies ERC-4337.

The official implementation additionally contains:

* ECDSA verification
* EIP-712 hashing
* Bundlers
* Paymasters
* Factories
* Counterfactual deployment
* Signature aggregators
* Gas accounting
* Deposits
* Stakes
* Simulation (`simulateValidation`)
* Replay protection
* Multiple UserOperations per bundle

Those additions make the production contracts much more complex but do not change the core architectural pattern presented here.

---

# Summary

ERC-4337 transforms Ethereum wallets from **simple key holders** into **fully programmable smart contracts**.

Instead of Ethereum deciding how authentication works, developers can implement their own authorization logic directly in Solidity.

That single design decision enables multisig wallets, social recovery, passkeys, gas sponsorship, batching, spending limits, session keys, and many other features that are impossible with traditional EOAs.

---

For more information, please visit [Yaghoub Adelzadeh's GitHub](https://www.github.com/dappteacher).
```