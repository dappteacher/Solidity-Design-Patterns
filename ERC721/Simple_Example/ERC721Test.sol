// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher

pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "../src/ERC721.sol";

contract ERC721Test is Test {
    ERC721 private erc721;
    address private owner;
    address private user1;
    address private user2;

    // Run before each test
    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
        erc721 = new ERC721("TestToken", "TTK");
    }

    // Test the getInfo function
    function testGetInfo() public {
        (string memory name, string memory symbol) = erc721.getInfo();
        assertEq(name, "TestToken");
        assertEq(symbol, "TTK");
    }

    // Test the mint function
    function testMint() public {
        erc721.mint(user1, 1, "https://token-uri.com/1");
        assertEq(erc721.balanceOf(user1), 1);
        assertEq(erc721.getOwnerbyTokenId(1), user1);
        assertEq(erc721.getTokenURI(1), "https://token-uri.com/1");
    }

    // Test the transfer function
    function testTransfer() public {
        erc721.mint(user1, 1, "https://token-uri.com/1");
        vm.prank(user1);
        erc721.transfer(1, user2);
        assertEq(erc721.balanceOf(user1), 0);
        assertEq(erc721.balanceOf(user2), 1);
        assertEq(erc721.getOwnerbyTokenId(1), user2);
    }

    // Test the approve function
    function testApprove() public {
        erc721.mint(owner, 1, "https://token-uri.com/1");
        erc721.approve(user1, 1);
        assertEq(erc721.getApproval(1), user1);
    }

    // Test the setOperator function
    function testSetOperator() public {
        erc721.setOperator(user1);
        assertTrue(erc721.getOperator(user1));
    }

    // Test the removeOperator function
    function testRemoveOperator() public {
        erc721.setOperator(user1);
        erc721.removeOperator(user1);
        assertFalse(erc721.getOperator(user1));
    }

    // Test the transferFrom function
    function testTransferFrom() public {
        erc721.mint(owner, 1, "https://token-uri.com/1");
        erc721.approve(user1, 1);
        vm.prank(user1);
        erc721.transferFrom(owner, user2, 1);
        assertEq(erc721.balanceOf(owner), 0);
        assertEq(erc721.balanceOf(user2), 1);
        assertEq(erc721.getOwnerbyTokenId(1), user2);
    }
}
