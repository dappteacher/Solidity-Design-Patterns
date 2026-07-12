// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;
/// @title Combined Randomness Contract
/// @dev This contract generates randomness using multiple sources of entropy.
contract CombinedRandomness {

    /// @dev Event emitted when a random number is generated
    /// @param randomNumber The generated random number
    event RandomNumberGenerated(uint256 randomNumber);

    /// @notice Generates a random number using multiple sources of entropy
    /// @return A random number
    function getRandomNumber() public returns (uint256) {
        // Generate a random number using multiple sources
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp, msg.sender, gasleft(), tx.gasprice)));

        // Emit the random number generated event
        emit RandomNumberGenerated(randomNumber);

        // Return the random number
        return randomNumber;
    }
}
