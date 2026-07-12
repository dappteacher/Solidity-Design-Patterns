// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher

pragma solidity ^0.8.25;

/**
 * @title UsingLocalOrGlobalVars
 * @dev This contract demonstrates how to manipulate local and global variables using inline assembly in Solidity.
 */
contract UsingLocalOrGlobalVars {
    uint256 public globalVar;

    /**
     * @dev Initializes the contract by setting the `globalVar` to 10.
     */
    constructor() {
        globalVar = 10;
    }

    /**
     * @notice Sets the value of the global variable `globalVar`.
     * @dev Uses inline assembly to store the value in the storage slot of `globalVar`.
     * @param _value The new value to set for `globalVar`.
     */
    function setGlobalVar(uint256 _value) public {
        assembly {
            sstore(globalVar.slot, _value)
        }
    }

    /**
     * @notice Gets the value of the global variable `globalVar`.
     * @dev Uses inline assembly to load the value from the storage slot of `globalVar`.
     * @return The current value of `globalVar`.
     */
    function getGlobalVar() public view returns (uint256) {
        uint256 value;
        assembly {
            value := sload(globalVar.slot)
        }
        return value;
    }

    /**
     * @notice Adds two local variables.
     * @dev Uses inline assembly to add two `uint256` values.
     * @param a The first value.
     * @param b The second value.
     * @return result The sum of `a` and `b`.
     */
    function addLocalVars(uint256 a, uint256 b) public pure returns (uint256 result) {
        assembly {
            let sum := add(a, b)
            result := sum
        }
    }

    /**
     * @notice Multiplies two local variables.
     * @dev Uses inline assembly to multiply two `uint256` values.
     * @param a The first value.
     * @param b The second value.
     * @return result The product of `a` and `b`.
     */
    function multiplyLocalVars(uint256 a, uint256 b) public pure returns (uint256 result) {
        assembly {
            let product := mul(a, b)
            result := product
        }
    }
}

