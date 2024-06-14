// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher

pragma solidity ^0.8.25;

import "./Agreement.sol";

/**
 * @title Factory
 * @dev Contract for creating and managing Agreement contracts using the factory design pattern.
 */
contract Factory {
    // Contract owner address
    address owner;

    // Agreement contract instance
    Agreement myAgreement;

    // Mapping to keep track of generated token IDs
    mapping(uint256 counter => uint256 tokenId) private tokensGenerated;

    // Mapping from token ID to contract address
    mapping(uint256 tokenId => address contractAddress) contracts;

    // Counter for the number of tokens generated
    uint256 tokenCounter = 0;

    // Event to be emitted when an Agreement contract is created
    event AgreementCreated(address Agreement_Address);

    /**
     * @dev Constructor that sets the owner of the contract to the deployer.
     */
    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Function to mint a new Agreement token.
     * @param _owner The address of the token owner.
     * @param _tokenId The ID of the token to be minted.
     * @param _amount The amount of tokens to be minted.
     * @param _tokenURI The URI of the token.
     * @param _operators The addresses of the operators.
     * @param _operatorsNumbers The number of operators.
     */
    function selfMint(address _owner, uint256 _tokenId, uint256 _amount,
                      string memory _tokenURI, address[] memory _operators, uint8 _operatorsNumbers) 
                      public onlyOwner {
        // Check if the token ID already exists
        for (uint i = 0; i < tokenCounter; i++) {
            if (tokensGenerated[i] == _tokenId) {
                revert("This token ID already exists!");
            }
        }

        // Create a new Agreement contract
        myAgreement = new Agreement(_owner, _tokenId, _amount, _tokenURI, _operators, _operatorsNumbers);

        // Store the generated token ID and its contract address
        tokensGenerated[tokenCounter] = _tokenId;
        tokenCounter++;
        contracts[_tokenId] = address(myAgreement);

        // Emit the AgreementCreated event
        emit AgreementCreated(address(myAgreement));
    }

    /**
     * @dev Function to get the addresses of all created Agreement contracts.
     * @return ids The array of token IDs.
     * @return addresses The array of contract addresses.
     */
    function getContracts() public view returns (uint256[] memory ids, address[] memory addresses) {
        ids = new uint256[](tokenCounter);
        addresses = new address[](tokenCounter);

        for (uint8 i = 0; i < tokenCounter; i++) {
            ids[i] = tokensGenerated[i];
            addresses[i] = contracts[ids[i]];
        }
        return (ids, addresses);
    }

    /**
     * @dev Function to get the information of all generated tokens.
     * @return TokenCounter The total number of tokens generated.
     * @return TokenIds The array of token IDs.
     */
    function getTokensInformation() public view returns (uint256 TokenCounter, uint256[] memory TokenIds) {
        TokenIds = new uint256[](tokenCounter);
        for (uint256 i = 0; i < tokenCounter; i++) {
            TokenIds[i] = tokensGenerated[i];
        }
        return (tokenCounter, TokenIds);
    }

    /**
     * @dev Modifier to restrict function access to the contract owner.
     */
    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
}
