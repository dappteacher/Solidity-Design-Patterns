// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher

pragma solidity ^0.8.25;

contract ERC721 {

    // Private variables for the token name, symbol, and owner address
    string private name;
    string private symbol;
    address private owner;
    
    // Constructor to initialize the contract with a name and symbol, and set the owner to the contract deployer
    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        owner = msg.sender;
    }

    // Mappings for token ownership, balances, approvals, token URIs, and operator approvals
    mapping (uint256 => address) private owners;
    mapping (address => uint256) private balances;
    mapping (uint256 => address) private tokenApproval;
    mapping (uint256 => string) private tokenURI;
    mapping (address => mapping (address => bool)) private tokenOperator;

    // Events for token minting and transferring
    event TokenMinted(address indexed destination, uint256 tokenId, string tokenURI);
    event TokenTransferred(address indexed origin, uint256 tokenId, address indexed destination);

    // Function to get the token name and symbol
    function getInfo() public view returns (string memory, string memory) {
        return (name, symbol);
    }

    // Function to mint a new token
    // @param _destination The address of the token recipient
    // @param _tokenId The ID of the token to be minted
    // @param _tokenURI The URI of the token
    function mint(address _destination, uint256 _tokenId, string memory _tokenURI) public onlyOwner {
        require(_destination != address(0), "Invalid address");
        balances[_destination]++;
        owners[_tokenId] = _destination;
        tokenURI[_tokenId] = _tokenURI;
        emit TokenMinted(_destination, _tokenId, _tokenURI);
    }

    // Function to transfer a token
    // @param _tokenId The ID of the token to be transferred
    // @param _destination The address of the token recipient
    function transfer(uint256 _tokenId, address _destination) public {
        require(owners[_tokenId] == msg.sender, "Not authorized");
        require(_destination != address(0), "Invalid address");
        balances[msg.sender]--;
        balances[_destination]++;
        owners[_tokenId] = _destination;
        emit TokenTransferred(msg.sender, _tokenId, _destination);
    }

    // Function to get the owner of a token by its ID
    // @param _tokenId The ID of the token
    // @return The address of the token owner
    function getOwnerbyTokenId(uint256 _tokenId) public view returns (address) {
        return owners[_tokenId];
    }

    // Function to get the balance of a specific address
    // @param _owner The address to query the balance of
    // @return The balance of the specified address
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    // Function to approve an address to transfer a specific token
    // @param _to The address to be approved
    // @param _tokenId The ID of the token to approve
    function approve(address _to, uint256 _tokenId) public {
        require(msg.sender == owners[_tokenId], "Not authorized");
        require(_to != address(0), "Invalid address");
        tokenApproval[_tokenId] = _to;
    }

    // Function to get the approval address for a specific token
    // @param _tokenId The ID of the token
    // @return The address that is approved to transfer the token
    function getApproval(uint256 _tokenId) public view returns (address) {
        return tokenApproval[_tokenId];
    }

    // Function to set an operator for the caller's tokens
    // @param _operator The address to be set as an operator
    function setOperator(address _operator) public {
        require(_operator != address(0), "Invalid address");
        tokenOperator[msg.sender][_operator] = true;
    }

    // Function to check if an address is an operator for the caller
    // @param _checkOperator The address to check
    // @return True if the address is an operator, false otherwise
    function getOperator(address _checkOperator) public view returns (bool) {
        return tokenOperator[msg.sender][_checkOperator];
    }

    // Function to remove an operator for the caller's tokens
    // @param _account The address of the operator to be removed
    function removeOperator(address _account) public {
        require(_account != address(0), "Invalid address");
        tokenOperator[msg.sender][_account] = false;
    }

    // Function to transfer a token from one address to another
    // @param _from The address of the current token owner
    // @param _to The address of the token recipient
    // @param _tokenId The ID of the token to be transferred
    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        require(owners[_tokenId] == _from, "Transfer denied, You are not the owner of the token!");
        require(_from != address(0) && _to != address(0), "Invalid address");
        require(getApproval(_tokenId) == msg.sender || getOperator(msg.sender), "Access is denied!");
        balances[_from]--;
        balances[_to]++;
        owners[_tokenId] = _to;
        approve(_to, _tokenId);
        emit TokenTransferred(_from, _tokenId, _to);
    }

    // Function to get the URI of a specific token
    // @param _tokenId The ID of the token
    // @return The URI of the token
    function getTokenURI(uint256 _tokenId) public view returns (string memory) {
        return tokenURI[_tokenId];
    }

    // Modifier to restrict access to only the owner of the contract
    modifier onlyOwner {
        require(owner == msg.sender, "You are not the owner!");
        _;
    }
}
