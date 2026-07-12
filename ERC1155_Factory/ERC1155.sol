// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;

/**
 * @title ERC1155
 * @dev Abstract contract for ERC1155 tokens. This contract provides basic implementation
 *      and functions for ERC1155 tokens including minting, transferring, and operator approvals.
 */
abstract contract ERC1155 {
    // Token name
    string private name;

    // Token symbol
    string private symbol;

    // Token decimals (constant)
    uint8 private constant decimals = 2;

    /**
     * @dev Constructor initializes the token with a name and symbol.
     */
    constructor() {
        name = "Jacob";
        symbol = "JCB";
    }

    // Mapping from owner address to token ID to token balance
    mapping(address owner => mapping(uint256 tokenId => uint256 amount)) private balances;

    // Mapping from token ID to owner address
    mapping(uint256 tokenId => address owner) private owners;

    // Mapping from token ID to token URI
    mapping(uint256 tokenId => string hostAddress) tokenURI;

    // Mapping from owner address to operator address to token ID to approved amount
    mapping(address owner => mapping(address sender => mapping(uint256 tokenId => uint256 amount))) tokenOperator;

    /**
     * @dev Returns the token name and symbol.
     */
    function getInfo() public view returns (string memory, string memory) {
        return (name, symbol);
    }

    /**
     * @dev Mints new tokens and assigns them to the owner address.
     * @param _owner The address of the token owner.
     * @param _tokenId The ID of the token to be minted.
     * @param _amount The amount of tokens to be minted.
     * @param _tokenURI The URI of the token.
     */
    function mint(address _owner, uint256 _tokenId, uint256 _amount, string memory _tokenURI) internal {
        require(balances[_owner][_tokenId] == 0, "Already minted!");
        require(_owner != address(0), "Invalid address");
        balances[_owner][_tokenId] = _amount * 10 ** decimals;
        tokenURI[_tokenId] = _tokenURI;
    }

    /**
     * @dev Transfers tokens to a specified address.
     * @param _tokenId The ID of the token to be transferred.
     * @param _amount The amount of tokens to be transferred.
     * @param _destination The address to transfer the tokens to.
     */
    function transfer(uint256 _tokenId, uint256 _amount, address _destination) public {
        require(_destination != address(0), "Invalid address");
        require(balances[msg.sender][_tokenId] >= _amount, "Insufficient balance");
        balances[msg.sender][_tokenId] -= _amount;
        balances[_destination][_tokenId] += _amount;
    }

    /**
     * @dev Returns the balance of tokens for a specific account and token ID.
     * @param _account The address of the account.
     * @param _tokenId The ID of the token.
     */
    function balanceOf(address _account, uint256 _tokenId) public view returns (uint256) {
        return balances[_account][_tokenId];
    }

    /**
     * @dev Approves an operator to spend a specific amount of tokens on behalf of the owner.
     * @param _operator The address of the operator.
     * @param _tokenId The ID of the token.
     * @param _amount The amount of tokens to be approved.
     */
    function approveOperator(address _operator, uint256 _tokenId, uint256 _amount) public {
        require(balances[msg.sender][_tokenId] >= _amount, "You should generate token with this tokenId");
        require(_operator != address(0), "Invalid address");
        tokenOperator[msg.sender][_operator][_tokenId] = _amount;
    }

    /**
     * @dev Removes an operator's approval to spend tokens on behalf of the owner.
     * @param _operator The address of the operator.
     * @param _tokenId The ID of the token.
     */
    function removeOperator(address _operator, uint256 _tokenId) public {
        require(_operator != address(0), "Invalid address");
        tokenOperator[msg.sender][_operator][_tokenId] = 0;
    }

    /**
     * @dev Returns the approved amount for an operator on behalf of an owner.
     * @param _owner The address of the token owner.
     * @param _operator The address of the operator.
     * @param _tokenId The ID of the token.
     */
    function getOperator(address _owner, address _operator, uint256 _tokenId) public view returns (uint256) {
        return tokenOperator[_owner][_operator][_tokenId];
    }

    /**
     * @dev Transfers tokens from one address to another on behalf of the owner.
     * @param _owner The address of the token owner.
     * @param _to The address to transfer the tokens to.
     * @param _tokenId The ID of the token.
     * @param _amount The amount of tokens to be transferred.
     */
    function transferFrom(address _owner, address _to, uint256 _tokenId, uint256 _amount) public {
        require(_owner != address(0), "Invalid address");
        require(_to != address(0), "Invalid address");
        require(_amount <= balances[_owner][_tokenId], "Insufficient balance");

        if (_owner != msg.sender) {
            require(_amount <= tokenOperator[_owner][msg.sender][_tokenId], "Access denied!");
            uint256 amount = getOperator(_owner, msg.sender, _tokenId);
            amount -= _amount;
            tokenOperator[_owner][msg.sender][_tokenId] = amount;
        }

        balances[_owner][_tokenId] -= _amount;
        balances[_to][_tokenId] += _amount;
    }
}
