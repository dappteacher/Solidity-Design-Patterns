// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher

pragma solidity ^0.8.25;

import {Test} from "forge-std/Test.sol";
import {ERC20} from "../src/ERC20.sol"; // Adjust the path according to your project structure

contract ERC20Test is Test {
    ERC20 private token;
    address private owner = address(this); // Set the owner to this contract
    address private addr1 = address(0x1);
    address private addr2 = address(0x2);
    uint256 private initialSupply = 1000 * 10**18;

    function setUp() public {
        token = new ERC20("TestToken", "TTK");
        token._mint(owner, initialSupply);
    }

    function testInitialSetup() public {
        assertEq(token.name(), "TestToken");
        assertEq(token.symbol(), "TTK");
        assertEq(token.decimals(), 18);
        assertEq(token.totalSupply(), initialSupply);
        assertEq(token.balanceOf(owner), initialSupply);
    }

    function testTransfer() public {
        uint256 transferAmount = 100 * 10**18;
        token.transfer(addr1, transferAmount);
        assertEq(token.balanceOf(owner), initialSupply - transferAmount);
        assertEq(token.balanceOf(addr1), transferAmount);
    }

    function testApproveAndTransferFrom() public {
        uint256 approveAmount = 100 * 10**18;
        uint256 transferAmount = 50 * 10**18;

        token.approve(addr1, approveAmount);
        vm.prank(addr1);
        token.transferFrom(owner, addr2, transferAmount);

        assertEq(token.allowance(owner, addr1), approveAmount - transferAmount);
        assertEq(token.balanceOf(owner), initialSupply - transferAmount);
        assertEq(token.balanceOf(addr2), transferAmount);
    }

    function testIncreaseDecreaseAllowance() public {
        uint256 initialAllowance = 100 * 10**18;
        uint256 increaseAmount = 50 * 10**18;
        uint256 decreaseAmount = 30 * 10**18;

        token.approve(addr1, initialAllowance);
        token.increaseAllowance(addr1, increaseAmount);
        assertEq(token.allowance(owner, addr1), initialAllowance + increaseAmount);

        token.decreaseAllowance(addr1, decreaseAmount);
        assertEq(token.allowance(owner, addr1), initialAllowance + increaseAmount - decreaseAmount);
    }

    function testMint() public {
        uint256 mintAmount = 200 * 10**18;
        token._mint(owner, mintAmount);
        assertEq(token.totalSupply(), initialSupply + mintAmount);
        assertEq(token.balanceOf(owner), initialSupply + mintAmount);
    }

    function testBurn() public {
        uint256 burnAmount = 100 * 10**18;
        token._burn(owner, burnAmount);
        assertEq(token.totalSupply(), initialSupply - burnAmount);
        assertEq(token.balanceOf(owner), initialSupply - burnAmount);
    }
}
