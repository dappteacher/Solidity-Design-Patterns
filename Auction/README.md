
```markdown
# Auction Contracts

This repository contains Solidity smart contracts for creating and managing auctions of ERC721 NFTs. The contracts included are `SimpleAuction` and `AuctionFactory`.

## SimpleAuction

The `SimpleAuction` contract allows for the auctioning of an ERC721 NFT. It includes functionalities for starting the auction, placing bids, withdrawing bids, and ending the auction.

### Features

- **Start Auction**: Only the seller can start the auction.
- **Place Bids**: Users can place bids higher than the current highest bid.
- **Withdraw Bids**: Users can withdraw their bids if they are not the highest bidder.
- **End Auction**: Ends the auction and transfers the NFT to the highest bidder or returns it to the seller if no bids were placed.


## AuctionFactory

The `AuctionFactory` contract is used to create instances of the `SimpleAuction` contract. It allows the owner to create new auctions and provides functionality to retrieve auction details.

### Features

- **Create New Auction**: Only the owner can create new auctions.
- **Retrieve Auction Details**: Users can get details of a specific auction by providing the auction contract address.


## License

This project is licensed under the MIT License. See the [LICENSE](../LICENSE) file for details.

---

For more information, please visit [Yaghoub Adelzadeh's GitHub](https://www.github.com/dappteacher).
```
