// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;

contract ChecksEffectsInteractions {
    mapping(address => uint256) private balances;

    /**
     * @dev Deposits Ether into the bank.
     */
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] += msg.value;
    }

    /**
     * @dev Withdraws Ether from the bank.
     * @param _amount The amount of Ether to withdraw.
     */
    function withdraw(uint256 _amount) public {
        // Checks
        require(_amount > 0, "Withdraw amount must be greater than zero");
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        // Effects
        balances[msg.sender] -= _amount;

        // Interactions
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Failed to send Ether");
    }

    /**
     * @dev Returns the balance of the caller.
     * @return The balance of the caller.
     */
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}
