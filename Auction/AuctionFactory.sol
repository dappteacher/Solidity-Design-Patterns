// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.26;

import "./SimpleAuction.sol";

/**
 * @title AuctionFactory
 * @dev This contract is used to create instances of SimpleAuction contracts.
 */
contract AuctionFactory {
    // Owner of the contract
    address owner;

    /**
     * @dev Initializes the contract setting the deployer as the owner.
     */
    constructor() {
        owner = msg.sender;
    }

    // Struct representing an auction's details
    struct Auction {
        address nftAddress;
        uint256 nftID;
        uint256 bidStarting;
    }

    // The most recently created auction
    SimpleAuction public auction;
    // Mapping to store auction details by their address
    mapping(address => Auction) public auctions;

    // Events
    event AuctionCreated(address indexed NFTAddress, uint256 nftID, uint256 BIDStarting);
    event NewAddress(address indexed AuctionAddress);

    /**
     * @dev Creates a new auction with the specified NFT and starting bid.
     * Can only be called by the owner.
     * @param _nft Address of the ERC721 contract.
     * @param _nftId ID of the NFT to be auctioned.
     * @param _startingBid Initial bid amount.
     */
    function newAuction(address _nft, uint256 _nftId, uint256 _startingBid) public onlyOwner {
        auction = new SimpleAuction(_nft, _nftId, _startingBid);
        auctions[address(auction)] = Auction(_nft, _nftId, _startingBid);
        emit AuctionCreated(_nft, _nftId, _startingBid);
        emit NewAddress(address(auction));
    }

    /**
     * @dev Returns the details of an auction.
     * @param _auction Address of the auction contract.
     * @return nftAddress_ Address of the NFT contract.
     * @return nftId_ ID of the NFT being auctioned.
     * @return bidStarting_ Starting bid amount of the auction.
     */
    function getAuction(address _auction) public view returns (address nftAddress_, uint256 nftId_, uint256 bidStarting_) {
        nftAddress_ = auctions[_auction].nftAddress;
        nftId_ = auctions[_auction].nftID;
        bidStarting_ = auctions[_auction].bidStarting;
    }

    /**
     * @dev Modifier to check if the caller is the owner.
     */
    modifier onlyOwner {
        require(owner == msg.sender, "Not the contract owner");
        _;
    }
}
