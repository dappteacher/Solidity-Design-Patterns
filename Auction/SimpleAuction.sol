// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.26;

interface IERC721 {
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function transferFrom(address from, address to, uint256 tokenId) external;
}

/**
 * @title SimpleAuction
 * @dev This contract allows for the auctioning of an ERC721 NFT.
 */
contract SimpleAuction {
    // Events
    event Start();
    event Bid(address indexed sender, uint256 amount);
    event Withdraw(address indexed bidder, uint256 amount);
    event End(address winner, uint256 amount);

    // State variables
    IERC721 public nft;
    uint256 public nftId;
    address payable public seller;
    uint256 public endAt;
    bool public started;
    bool public ended;

    address public highestBidder;
    uint256 public highestBid;
    mapping(address => uint256) public bids;

    /**
     * @dev Initializes the auction with the NFT contract address, NFT ID, and starting bid amount.
     * @param _nft Address of the ERC721 contract.
     * @param _nftId ID of the NFT to be auctioned.
     * @param _startingBid Initial bid amount.
     */
    constructor(address _nft, uint256 _nftId, uint256 _startingBid) {
        nft = IERC721(_nft);
        nftId = _nftId;

        seller = payable(msg.sender);
        highestBid = _startingBid;
    }

    /**
     * @dev Starts the auction by transferring the NFT from the seller to the contract.
     * Can only be called by the seller.
     */
    function start() external {
        require(!started, "Auction already started");
        require(msg.sender == seller, "Only the seller can start the auction");

        nft.transferFrom(msg.sender, address(this), nftId);
        started = true;
        endAt = block.timestamp + 7 days;

        emit Start();
    }

    /**
     * @dev Places a bid on the auction. The bid must be higher than the current highest bid.
     */
    function bid() external payable {
        require(started, "Auction not started yet");
        require(block.timestamp < endAt, "Auction already ended");
        require(msg.value > highestBid, "Bid amount must be higher than current highest bid");

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        emit Bid(msg.sender, msg.value);
    }

    /**
     * @dev Allows a bidder to withdraw their bid amount if they are not the highest bidder.
     */
    function withdraw() external {
        uint256 bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);

        emit Withdraw(msg.sender, bal);
    }

    /**
     * @dev Ends the auction and transfers the NFT to the highest bidder. If there are no bids, the NFT is returned to the seller.
     */
    function end() external {
        require(started, "Auction not started yet");
        require(block.timestamp >= endAt, "Auction not ended yet");
        require(!ended, "Auction already ended");

        ended = true;
        if (highestBidder != address(0)) {
            nft.safeTransferFrom(address(this), highestBidder, nftId);
            seller.transfer(highestBid);
        } else {
            nft.safeTransferFrom(address(this), seller, nftId);
        }

        emit End(highestBidder, highestBid);
    }
}
