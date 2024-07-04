// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher

pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/CustodianExample.sol";

contract CustodianExampleTest is Test {
    CustodianExample token;
    address custodian = address(0xC0ffEE);
    address user1 = address(0x123);
    address user2 = address(0x456);

    /// @notice Sets up the test environment by deploying the CustodianExample contract.
    function setUp() public {
        token = new CustodianExample(custodian);
    }

    /// @notice Tests the initial values of the CustodianExample contract.
    function testInitialValues() public {
        assertEq(token.name(), "Tether Token");
        assertEq(token.symbol(), "USDT");
        assertEq(token.decimals(), 18);
        assertEq(token.totalSupply(), 0);
        assertEq(token.owner(), address(this));
        assertEq(token.custodian(), custodian);
    }

    /// @notice Tests the mint function to ensure only the custodian can mint tokens.
    function testMint() public {
        vm.prank(custodian);
        token.mint(user1, 1000);

        assertEq(token.balanceOf(user1), 1000);
        assertEq(token.totalSupply(), 1000);
    }

    /// @notice Tests that minting tokens from a non-custodian address reverts.
    function testMintNotCustodian() public {
        vm.expectRevert("Caller is not the custodian");
        token.mint(user1, 1000);
    }

    /// @notice Tests the burn function to ensure only the custodian can burn tokens.
    function testBurn() public {
        vm.prank(custodian);
        token.mint(user1, 1000);

        vm.prank(custodian);
        token.burn(user1, 500);

        assertEq(token.balanceOf(user1), 500);
        assertEq(token.totalSupply(), 500);
    }

    /// @notice Tests that burning tokens from a non-custodian address reverts.
    function testBurnNotCustodian() public {
        vm.prank(custodian);
        token.mint(user1, 1000);

        vm.expectRevert("Caller is not the custodian");
        token.burn(user1, 500);
    }

    /// @notice Tests the transfer function to ensure tokens can be transferred between accounts.
    function testTransfer() public {
        vm.prank(custodian);
        token.mint(user1, 1000);

        vm.prank(user1);
        token.transfer(user2, 300);

        assertEq(token.balanceOf(user1), 700);
        assertEq(token.balanceOf(user2), 300);
    }

    /// @notice Tests that transferring tokens with insufficient balance reverts.
    function testTransferInsufficientBalance() public {
        vm.prank(custodian);
        token.mint(user1, 1000);

        vm.prank(user1);
        vm.expectRevert("Insufficient balance");
        token.transfer(user2, 1500);
    }

    /// @notice Tests the approve and transferFrom functions to ensure delegated transfers work correctly.
    function testApproveAndTransferFrom() public {
        vm.prank(custodian);
        token.mint(user1, 1000);

        vm.prank(user1);
        token.approve(user2, 500);

        vm.prank(user2);
        token.transferFrom(user1, user2, 300);

        assertEq(token.balanceOf(user1), 700);
        assertEq(token.balanceOf(user2), 300);
        assertEq(token.allowance(user1, user2), 200);
    }

    /// @notice Tests that transferring tokens exceeding the allowance reverts.
    function testApproveInsufficientBalance() public {
        vm.prank(custodian);
        token.mint(user1, 1000);

        vm.prank(user1);
        token.approve(user2, 1500);

        vm.prank(user2);
        vm.expectRevert("Allowance exceeded");
        token.transferFrom(user1, user2, 1500);
    }
}
