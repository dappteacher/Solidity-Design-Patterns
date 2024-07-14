// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.0;

contract MultiSigWallet {
    address[] public owners;
    uint public requiredConfirmations;
    uint public transactionCount;
    
    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
        uint numConfirmations;
    }
    
    mapping(uint => mapping(address => bool)) public isConfirmed;
    mapping(uint => Transaction) public transactions;
    
    modifier onlyOwner() {
        bool isOwner = false;
        for (uint i = 0; i < owners.length; i++) {
            if (owners[i] == msg.sender) {
                isOwner = true;
                break;
            }
        }
        require(isOwner, "Not owner");
        _;
    }
    
    modifier txExists(uint _txIndex) {
        require(_txIndex < transactionCount, "Transaction does not exist");
        _;
    }
    
    modifier notExecuted(uint _txIndex) {
        require(!transactions[_txIndex].executed, "Transaction already executed");
        _;
    }
    
    modifier notConfirmed(uint _txIndex) {
        require(!isConfirmed[_txIndex][msg.sender], "Transaction already confirmed");
        _;
    }
    
    event Deposit(address indexed sender, uint amount, uint balance);
    event SubmitTransaction(
        address indexed owner,
        uint indexed txIndex,
        address indexed to,
        uint value,
        bytes data
    );
    event ConfirmTransaction(address indexed owner, uint indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint indexed txIndex);
    event ExecuteTransaction(address indexed owner, uint indexed txIndex);
    
    // @dev Initializes the contract with a list of owners and the number of required confirmations.
    // @param _owners List of wallet owners.
    // @param _requiredConfirmations Number of confirmations required for a transaction to be executed.
    constructor(address[] memory _owners, uint _requiredConfirmations) {
        require(_owners.length > 0, "Owners required");
        require(
            _requiredConfirmations > 0 &&  _requiredConfirmations <= _owners.length,
            "Invalid required confirmations"
        );
        
        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            
            require(owner != address(0), "Invalid owner");
            require(!isOwner(owner), "Owner not unique");
            
            owners.push(owner);
        }
        
        requiredConfirmations = _requiredConfirmations;
    }
    
    // @dev Allows the contract to receive Ether.
    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }
    
    // @dev Submits a transaction for confirmation.
    // @param _to Address to which the transaction is sent.
    // @param _value Amount of Ether to send.
    // @param _data Data to send with the transaction.
    function submitTransaction(address _to, uint _value, bytes memory _data)
        public
        onlyOwner
    {
        uint txIndex = transactionCount;
        
        transactions[txIndex] = Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false,
            numConfirmations: 0
        });
        
        transactionCount += 1;
        
        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
    }
    
    // @dev Confirms a transaction.
    // @param _txIndex Index of the transaction to confirm.
    function confirmTransaction(uint _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
        notConfirmed(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        transaction.numConfirmations += 1;
        isConfirmed[_txIndex][msg.sender] = true;
        
        emit ConfirmTransaction(msg.sender, _txIndex);
    }
    
    // @dev Executes a confirmed transaction.
    // @param _txIndex Index of the transaction to execute.
    function executeTransaction(uint _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        
        require(
            transaction.numConfirmations >= requiredConfirmations,
            "Cannot execute transaction"
        );
        
        transaction.executed = true;
        
        (bool success, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );
        require(success, "Transaction failed");
        
        emit ExecuteTransaction(msg.sender, _txIndex);
    }
    
    // @dev Revokes a confirmation for a transaction.
    // @param _txIndex Index of the transaction to revoke confirmation for.
    function revokeConfirmation(uint _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        
        require(isConfirmed[_txIndex][msg.sender], "Transaction not confirmed");
        
        transaction.numConfirmations -= 1;
        isConfirmed[_txIndex][msg.sender] = false;
        
        emit RevokeConfirmation(msg.sender, _txIndex);
    }
    
    // @dev Checks if an address is an owner.
    // @param _owner Address to check.
    // @return Boolean indicating whether the address is an owner.
    function isOwner(address _owner) private view returns (bool) {
        for (uint i = 0; i < owners.length; i++) {
            if (owners[i] == _owner) {
                return true;
            }
        }
        return false;
    }
    
    // @dev Returns the details of a transaction.
    // @param _txIndex Index of the transaction to return.
    // @return to Address to which the transaction is sent.
    // @return value Amount of Ether to send.
    // @return data Data to send with the transaction.
    // @return executed Boolean indicating whether the transaction has been executed.
    // @return numConfirmations Number of confirmations received.
    function getTransaction(uint _txIndex)
        public
        view
        returns (
            address to,
            uint value,
            bytes memory data,
            bool executed,
            uint numConfirmations
        )
    {
        Transaction storage transaction = transactions[_txIndex];
        
        return (
            transaction.to,
            transaction.value,
            transaction.data,
            transaction.executed,
            transaction.numConfirmations
        );
    }
    
    // @dev Returns the list of owners.
    // @return List of owner addresses.
    function getOwners() public view returns (address[] memory) {
        return owners;
    }
    
    // @dev Returns the number of transactions.
    // @return Number of transactions.
    function getTransactionCount() public view returns (uint) {
        return transactionCount;
    }
}
