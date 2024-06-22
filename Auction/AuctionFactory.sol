// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.26;

import "./SimpleAuction.sol";

contract AuctionFactory {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    struct Auction {
        address nftAddress;
        uint256 nftID;
        uint256 bidStarting;
    }

    SimpleAuction public auction;
    mapping(address => Auction) public auctions;

    event AuctionCreated(address NFTAddress, uint256 nftID, uint256 BIDStarting);
    event NewAddress(address AuctionAddress);

    function newAuction(address _nft, uint256 _nftId, uint256 _startingBid) public onlyOwner {
        auction = new SimpleAuction(_nft, _nftId, _startingBid);
        auctions[address(auction)] = Auction(_nft, _nftId, _startingBid);
        emit AuctionCreated(_nft, _nftId, _startingBid);
        emit NewAddress(address(auction));
    }

    function getAuction(address _auction) public view returns (address nftAddress_, uint256 nftId_, uint256 bidStarting_) {
        nftAddress_ = auctions[_auction].nftAddress;
        nftId_ = auctions[_auction].nftID;
        bidStarting_ = auctions[_auction].bidStarting;
    }

    modifier onlyOwner {
        require(owner == msg.sender, "Not the contract owner");
        _;
    }
}
