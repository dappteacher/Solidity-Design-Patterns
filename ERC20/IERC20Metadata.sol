// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher

pragma solidity ^0.8.25;

import "./IERC20.sol";

// Interface for the optional metadata functions from the ERC20 standard.
interface IERC20Metadata is IERC20 {
    // Returns the name of the token.
    function name() external view returns (string memory);

    // Returns the symbol of the token.
    function symbol() external view returns (string memory);

    // Returns the number of decimals the token uses.
    function decimals() external view returns (uint8);
}