// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher

pragma solidity ^0.8.25;

contract MemoryCopyExample {

    /**
     * @notice Copies the contents of one memory array to another memory array using inline assembly.
     * @param source The source memory array.
     * @param destination The destination memory array.
     */
    function copyMemory(uint[] memory source, uint[] memory destination) public pure {
        assembly {
            // Calculate the length of the source array
            let length := mload(source)

            // Calculate the length of the destination array
            let destLength := mload(destination)

            // Check if the destination array is long enough to hold the source array
            if lt(destLength, length) {
                // If not, revert the transaction
                revert(0, 0)
            }

            // Skip the length field (32 bytes) to get to the actual data
            source := add(source, 0x20)
            destination := add(destination, 0x20)

            // Copy memory from source to destination
            for { let i := 0 } lt(i, mul(length, 0x20)) { i := add(i, 0x20) } {
                mstore(add(destination, i), mload(add(source, i)))
            }
        }
    }
}
