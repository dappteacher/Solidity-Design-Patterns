# Uniswap Swap Contracts

## Introduction

This repository contains example smart contracts for swapping tokens using the Uniswap V2 and V3 protocols. 
These contracts allow users to swap ERC-20 tokens through the Uniswap decentralized exchange.

## Contracts

### Uniswap V2 Swap Contract

**File**: `UniswapV2Swap.sol`

This contract enables users to swap tokens on Uniswap V2.


### Uniswap V3 Swap Contract

**File**: `UniswapV3Swap.sol`

This contract enables users to swap tokens on Uniswap V3.


## Differences Between Uniswap V2 and V3

### Capital Efficiency

- **Uniswap V2**: Liquidity is spread uniformly across the entire price range (0 to ∞), often leading to inefficient use of capital.
- **Uniswap V3**: Introduces concentrated liquidity, where LPs can specify price ranges, leading to higher capital efficiency and better use of funds.

### Fee Structure

- **Uniswap V2**: Flat 0.3% fee on all swaps, with no flexibility in fee tiers.
- **Uniswap V3**: Offers multiple fee tiers (e.g., 0.05%, 0.3%, and 1%), allowing LPs to choose their preferred fee level based on the pair and their risk/reward preferences.

### Liquidity Provision

- **Uniswap V2**: LPs provide liquidity across the entire price curve.
- **Uniswap V3**: LPs can choose specific price ranges to provide liquidity, enhancing capital efficiency and potential returns.

### Price Oracles

- **Uniswap V2**: Provides time-weighted average price (TWAP) oracles which are relatively simple but less resistant to manipulation.
- **Uniswap V3**: Enhances oracle functionality with more sophisticated TWAP calculations, improving security and accuracy for on-chain price feeds.

### Non-fungible Liquidity

- **Uniswap V2**: LP shares are represented as fungible ERC-20 tokens.
- **Uniswap V3**: LP shares are represented as non-fungible tokens (NFTs), allowing for more customized and granular liquidity positions.

### Efficiency and Flexibility

- **Uniswap V2**: Simpler to understand and use, but less efficient for professional or large-scale LPs.
- **Uniswap V3**: More efficient and flexible for LPs, providing tools for optimizing returns, but requires more active management and understanding of the market.

### Gas Costs

- **Uniswap V2**: Generally lower gas costs due to its simpler design and operations.
- **Uniswap V3**: Potentially higher gas costs due to the more complex logic of concentrated liquidity and additional features, though higher capital efficiency can offset these costs.

### User Experience

- **Uniswap V2**: Easier for new users and LPs due to its simplicity, with fewer customization options.
- **Uniswap V3**: Offers more sophisticated tools and customization for advanced users and professional traders, but has a steeper learning curve.

## Note

- Make sure to adjust the router address according to the network you are using (e.g., Mainnet, Ropsten, etc.).
- You might need to update the Solidity version (`pragma solidity ^0.8.0;`) to match the version compatible with your development environment and Uniswap contracts.
- Test the contracts thoroughly in a development environment before deploying them to a live network.

## Author

- **Yaghoub Adelzadeh**
- GitHub: [dappteacher](https://www.github.com/dappteacher)
```

This `README.md` file provides an overview of the Uniswap V2 and V3 swap contracts, their code, and the key differences between the two versions.
