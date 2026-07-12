// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;

/// @title Randomness Contract
/// @dev This contract generates secure randomness using block hashes and user-supplied seeds.
contract SimpleRandomness {

    /// @dev Event emitted when a random number is generated
    /// @param randomNumber The generated random number
    event RandomNumberGenerated(uint256 randomNumber);

    /// @notice Generates a random number based on block hash and a user-supplied seed
    /// @param seed A user-supplied seed for randomness
    /// @return A random number
    function getRandomNumber(uint256 seed) public returns (uint256) {
        // Generate a random number using keccak256 hash function
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), msg.sender, seed)));

        // Emit the random number generated event
        emit RandomNumberGenerated(randomNumber);

        // Return the random number
        return randomNumber;
    }
}
