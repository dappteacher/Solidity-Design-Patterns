// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title UserOperation
/// @notice Simplified version of ERC-4337 UserOperation.
///
/// In ERC-4337, users do NOT sign Ethereum transactions.
/// Instead, they sign a UserOperation which is later executed
/// by the EntryPoint contract.
struct UserOperation {
    /// Smart Account address
    address sender;

    /// Prevent replay attacks
    uint256 nonce;

    /// Destination contract
    address target;

    /// ETH value to send
    uint256 value;

    /// Encoded function call
    bytes data;

    /// User signature
    bytes signature;
}