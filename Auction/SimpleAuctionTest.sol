// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher

pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "./SimpleAuction.sol";

/**
 * @title SimpleAuctionTest
 * @dev This contract tests the functionality of the SimpleAuction contract using Foundry.
 */
contract SimpleAuctionTest is Test {
    SimpleAuction auction;
    IERC721 mockNFT;

    address seller = address(1);
    address bidder1 = address(2);
    address bidder2 = address(3);
    uint256 nftId = 1;
    uint256 startingBid = 1 ether;

    function setUp() public {
        mockNFT = IERC721(address(new MockNFT()));
        auction = new SimpleAuction(address(mockNFT), nftId, startingBid);
        deal(seller, 10 ether);
        deal(bidder1, 10 ether);
        deal(bidder2, 10 ether);
    }

    function testStartAuction() public {
        vm.prank(seller);
        mockNFT.transferFrom(seller, address(auction), nftId);
        vm.prank(seller);
        auction.start();
        
        assertEq(mockNFT.ownerOf(nftId), address(auction));
        assertEq(auction.started(), true);
    }

    function testBid() public {
        vm.prank(seller);
        auction.start();
        
        vm.prank(bidder1);
        auction.bid{value: 2 ether}();
        
        assertEq(auction.highestBid(), 2 ether);
        assertEq(auction.highestBidder(), bidder1);
    }

    function testWithdraw() public {
        vm.prank(seller);
        auction.start();
        
        vm.prank(bidder1);
        auction.bid{value: 2 ether}();
        
        vm.prank(bidder2);
        auction.bid{value: 3 ether}();
        
        vm.prank(bidder1);
        auction.withdraw();
        
        assertEq(bidder1.balance, 10 ether);
    }

    function testEndAuction() public {
        vm.prank(seller);
        auction.start();
        
        vm.prank(bidder1);
        auction.bid{value: 2 ether}();
        
        vm.warp(block.timestamp + 7 days + 1);
        
        vm.prank(seller);
        auction.end();
        
        assertEq(mockNFT.ownerOf(nftId), bidder1);
        assertEq(seller.balance, 2 ether);
    }
}

/**
 * @title MockNFT
 * @dev This contract is a mock implementation of the ERC721 standard for testing purposes.
 */
contract MockNFT is IERC721 {
    mapping(uint256 => address) public owners;
    
    function safeTransferFrom(address from, address to, uint256 tokenId) external override {
        require(owners[tokenId] == from, "MockNFT: transfer of token that is not own");
        owners[tokenId] = to;
    }
    
    function transferFrom(address from, address to, uint256 tokenId) external override {
        require(owners[tokenId] == from, "MockNFT: transfer of token that is not own");
        owners[tokenId] = to;
    }
    
    function mint(address to, uint256 tokenId) external {
        owners[tokenId] = to;
    }

    function ownerOf(uint256 tokenId) external view returns (address) {
        return owners[tokenId];
    }
}
