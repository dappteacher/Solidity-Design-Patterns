// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;

/// @title Oracle Randomness Contract
/// @dev This contract uses an external oracle to generate randomness.
contract OracleRandomness {

    /// @dev Event emitted when a random number is generated
    /// @param randomNumber The generated random number
    event RandomNumberGenerated(uint256 randomNumber);

    /// @dev Address of the oracle
    address public oracle;

    /// @dev Constructor to set the oracle address
    /// @param _oracle The address of the oracle
    constructor(address _oracle) {
        oracle = _oracle;
    }

    /// @notice Requests a random number from the oracle
    function requestRandomNumber() public {
        // Call the oracle to request a random number (hypothetical example)
        // oracle.requestRandomNumber();
    }

    /// @dev Callback function to receive the random number from the oracle
    /// @param randomNumber The generated random number from the oracle
    function fulfillRandomNumber(uint256 randomNumber) external {
        require(msg.sender == oracle, "Only the oracle can fulfill the request");
        
        // Emit the random number generated event
        emit RandomNumberGenerated(randomNumber);
    }
}
