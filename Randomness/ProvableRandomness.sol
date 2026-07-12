/*
### Using Oraclize/Provable

Oraclize, now known as Provable, is an oracle service that can be used to fetch data from the web, 
including random numbers from a trusted external source. 


#### 1. Install the Provable API:

```bash
npm install provable-api
```
*/
// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;

import "provable-api/provableAPI_0.5.sol";

/// @title Provable Randomness Contract
/// @dev This contract generates secure randomness using the Provable oracle service.
contract ProvableRandomness is usingProvable {

    uint256 public randomNumber;
    bytes32 public queryId;

    /// @dev Event emitted when a random number is requested
    event RandomNumberRequested(bytes32 queryId);

    /// @dev Event emitted when a random number is generated
    event RandomNumberGenerated(uint256 randomNumber);

    /// @notice Constructor to set up the Provable callback gas limit
    constructor() {
        provable_setProof(proofType_TLSNotary | proofStorage_IPFS);
    }

    /// @notice Requests randomness from Provable
    function requestRandomNumber() public payable {
        require(provable_getPrice("WolframAlpha") <= address(this).balance, "Not enough ETH to pay for Provable query");
        queryId = provable_query("WolframAlpha", "random number between 1 and 10000");
        emit RandomNumberRequested(queryId);
    }

    /// @dev Callback function used by Provable to deliver the random number
    /// @param _queryId ID of the query
    /// @param _result Result of the query
    function __callback(bytes32 _queryId, string memory _result, bytes memory /* _proof */) public override {
        require(msg.sender == provable_cbAddress(), "Invalid sender");
        randomNumber = uint256(keccak256(abi.encodePacked(_result))) % 10000 + 1;
        emit RandomNumberGenerated(randomNumber);
    }

    /// @notice Fallback function to receive ETH
    receive() external payable {}
}
/*

### Contract Structure:

- **randomNumber**: Stores the generated random number.
- **queryId**: Stores the query ID for tracking the Provable request.

### Events:

- **RandomNumberRequested**: Emitted when a randomness request is made.
- **RandomNumberGenerated**: Emitted when the random number is generated.

### Functions:

1. **constructor**: Sets up the Provable callback gas limit and proof type.
2. **requestRandomNumber**: Sends a query to Provable to fetch a random number from WolframAlpha.
3. **__callback**: Callback function that receives the random number from Provable, 
    hashes it, and emits the `RandomNumberGenerated` event.
4. **receive**: Fallback function to receive ETH for funding the Provable queries.

### Usage:

1. **Fund the Contract**: Send some ETH to the contract to cover the cost of Provable queries.
2. **Request Randomness**: Call `requestRandomNumber` to initiate the query to Provable.
3. **Receive Random Number**: The contract will automatically call the `__callback` function once 
    the random number is fetched and processed.

### Considerations:

- **Cost**: Using external services like Provable involves gas fees and possibly additional service costs.
- **Security**: Provable uses TLSNotary proofs to ensure the data fetched is not tampered with, providing 
    a higher level of security compared to on-chain methods.

Using Provable is a secure and decentralized way to fetch random numbers from an external source, 
    ensuring fairness and unpredictability in your smart contract.
*/    
