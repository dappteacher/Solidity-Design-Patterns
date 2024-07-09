// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher

pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "../src/SimpleRandomness.sol"; // Adjust the path as necessary

/// @title SimpleRandomnessTest
/// @dev This contract tests the SimpleRandomness contract using Foundry's Test framework
contract SimpleRandomnessTest is Test {
    SimpleRandomness public randomness;

    /// @dev Event to be captured in the test
    event RandomNumberGenerated(uint256 randomNumber);

    /// @notice Sets up the test environment
    /// @dev Deploys a new instance of the SimpleRandomness contract before each test
    function setUp() public {
        randomness = new SimpleRandomness();
    }

    /// @notice Tests the getRandomNumber function of the SimpleRandomness contract
    /// @dev Verifies that the random number generated is as expected and that the correct event is emitted
    function testGetRandomNumber() public {
        // Define a seed value
        uint256 seed = 12345;
        
        // Calculate the expected random number
        uint256 blockHash = uint256(blockhash(block.number - 1));
        uint256 expectedRandomNumber = uint256(keccak256(abi.encodePacked(blockHash, address(this), seed)));

        // Expect the RandomNumberGenerated event to be emitted with the expected random number
        vm.expectEmit(true, true, true, true);
        emit RandomNumberGenerated(expectedRandomNumber);

        // Call the getRandomNumber function
        uint256 randomNumber = randomness.getRandomNumber(seed);

        // Assert that the returned random number matches the expected value
        assertEq(randomNumber, expectedRandomNumber, "Random number does not match expected value");
    }
}
