// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher

pragma solidity ^0.8.25;

import "./ERC1155.sol";

/**
 * @title Agreement
 * @dev Contract that represents an agreement using the ERC1155 token standard.
 */
contract Agreement is ERC1155 {
    // Token decimals
    uint8 private constant decimals = 6;    

    address owner;
    uint256 private tokenID;
    uint40 month;

    /**
     * @dev Constructor initializes the contract with specified parameters and mints tokens.
     * @param _owner The address of the token owner.
     * @param _tokenId The ID of the token to be minted.
     * @param _amount The amount of tokens to be minted.
     * @param _tokenURI The URI of the token.
     * @param _operators The addresses of the operators.
     * @param _operatorsNumbers The number of operators.
     */
    constructor(address _owner, uint256 _tokenId, uint256 _amount,
                string memory _tokenURI, address[] memory _operators, uint8 _operatorsNumbers) {
        owner = msg.sender;
        tokenID = _tokenId;

        for (uint8 i = 0; i < _operatorsNumbers; i++) {
            operators[_operators[i]] = true;
        }
        mint(_owner, _tokenId, _amount, _tokenURI);
    }

    // Mapping of operator addresses
    mapping(address => bool) operators; 

    // Mapping of month to rate
    mapping(uint40 month => uint256 rate) monthRate;

    // Mapping of month to specification status
    mapping(uint40 month => bool specified) monthSpecefied;

    // Mapping to check if receiver has withdrawn for a month
    mapping(address receiverAddress => mapping(uint40 month => bool withdrew)) receiveChecking;

    // Mapping of owner address to profit amount
    mapping(address owner => uint256 amount) public profits;

    /**
     * @dev Sets the rate for the current month.
     * @param _rate The rate to be set.
     */
    function setRate(uint256 _rate) public onlyOperator {
        require(monthSpecefied[month] == false, "Already specified");
        monthRate[month] = _rate;
        monthSpecefied[month] = true;
        month++;
    }

    /**
     * @dev Sets the profits for a receiver for a specified month.
     * @param _receiver The address of the receiver.
     * @param _month The month for which profits are to be set.
     */
    function setProfitsOfMonth(address _receiver, uint40 _month) public onlyOperator {
        require(_receiver != address(0), "Invalid address");
        require(_month < month, "Not reach");
        require(monthSpecefied[_month] == true, "Not yet");
        require(receiveChecking[_receiver][_month] == false, "Already set!");

        uint myBalance = balanceOf(_receiver, tokenID);
        uint256 amount = myBalance * monthRate[_month] / 10 ** decimals;
        amount -= myBalance;

        receiveChecking[_receiver][_month] = true;
        profits[_receiver] += amount;
    }

    /**
     * @dev Returns the balance of the caller.
     * @return principalAmount The principal amount.
     * @return totalBalance The total balance including profits.
     */
    function getBalance() public view returns (uint256 principalAmount, uint256 totalBalance) {
        principalAmount = balanceOf(msg.sender, tokenID);
        totalBalance = principalAmount + profits[msg.sender]; 
    }

    /**
     * @dev Modifier to check if the caller is an operator.
     */
    modifier onlyOperator {
        require(operators[msg.sender] == true, "Access is denied!");
        _;
    }
}
