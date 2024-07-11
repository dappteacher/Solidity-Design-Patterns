// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;

/**
 * @title AssemblyFlowControl
 * @dev Demonstrates flow control statements using inline assembly in Solidity.
 */
contract AssemblyFlowControl {
    /**
     * @dev Checks if a number is even using assembly.
     * @param _num The number to check.
     * @return True if the number is even, false otherwise.
     */
    function isEven(uint256 _num) public pure returns (bool) {
        bool result;
        assembly {
            // Check if _num modulo 2 is zero
            if iszero(mod(_num, 2)) {
                result := 1
            }
        }
        return result;
    }

    /**
     * @dev Sums an array of numbers using a for loop in assembly.
     * @param _arr The array of numbers to sum.
     * @return The sum of the array elements.
     */
    function sumArray(uint256[] memory _arr) public pure returns (uint256) {
        uint256 sum;
        assembly {
            // Get the length of the array
            let len := mload(_arr)
            // Initialize the index to 0
            let i := 0
            // Loop through the array
            for { } lt(i, len) { i := add(i, 1) } {
                // Add the element to sum
                sum := add(sum, mload(add(add(_arr, 0x20), mul(i, 0x20))))
            }
        }
        return sum;
    }

    /**
     * @dev Finds the first index of a target number in an array using a while loop in assembly.
     * @param _arr The array to search.
     * @param _target The target number to find.
     * @return The index of the target number, or -1 if not found.
     */
    function findIndex(uint256[] memory _arr, uint256 _target) public pure returns (int256) {
        int256 index = -1;
        assembly {
            // Get the length of the array
            let len := mload(_arr)
            // Initialize the index to 0
            let i := 0
            // Loop through the array
            for { } lt(i, len) { } {
                // Check if the current element is the target
                if eq(mload(add(add(_arr, 0x20), mul(i, 0x20))), _target) {
                    index := i
                    break
                }
                i := add(i, 1)
            }
        }
        return index;
    }

    /**
     * @dev Performs an action based on the input using if-else statements to emulate switch-case.
     * @param _input The input to switch on.
     * @return The result of the case.
     */
    function switchCaseExample(uint256 _input) public pure returns (string memory) {
        if (_input == 0) {
            return "Input is zero";
        } else if (_input == 1) {
            return "Input is one";
        } else if (_input == 2) {
            return "Input is two";
        } else {
            return "Input is something else";
        }
    }
}
