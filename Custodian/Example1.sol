// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher

pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/// @title ERC20Token
/// @dev Implementation of the basic standard token (ERC20). This contract includes minting and burning functions
/// that can only be called by a designated custodian address.
contract CustodianExample is IERC20 {
    using SafeMath for uint256;

    // Token name
    string public name = "Tether Token";
    // Token symbol
    string public symbol = "USDT";
    // Number of decimals
    uint8 public decimals = 18;
    // Total token supply
    uint256 public override totalSupply;
    // Owner of the contract
    address public owner;
    // Custodian address (authorized to mint and burn tokens)
    address public custodian;

    // Mapping from address to token balance
    mapping(address => uint256) public override balanceOf;
    // Mapping from address to allowance amount
    mapping(address => mapping(address => uint256)) public override allowance;

    // Event emitted when tokens are minted
    event Mint(address indexed recipient, uint256 amount);
    // Event emitted when tokens are burned
    event Burn(address indexed sender, uint256 amount);

    // Modifier to restrict function access to the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    // Modifier to restrict function access to the custodian address
    modifier onlyCustodian() {
        require(msg.sender == custodian, "Caller is not the custodian");
        _;
    }

    /// @dev Constructor that sets the custodian address and initializes the owner.
    /// @param _custodian The address of the custodian.
    constructor(address _custodian) {
        require(_custodian != address(0), "Invalid custodian address");
        owner = msg.sender;
        custodian = _custodian;
    }

    /// @notice Mint new tokens.
    /// @dev Function to mint tokens. Can only be called by the custodian.
    /// @param recipient The address that will receive the minted tokens.
    /// @param amount The amount of tokens to mint.
    function mint(address recipient, uint256 amount) external onlyCustodian {
        require(recipient != address(0), "Invalid recipient address");
        balanceOf[recipient] = balanceOf[recipient].add(amount);
        totalSupply = totalSupply.add(amount);
        emit Mint(recipient, amount);
        emit Transfer(address(0), recipient, amount);
    }

    /// @notice Burn tokens.
    /// @dev Function to burn tokens. Can only be called by the custodian.
    /// @param sender The address whose tokens will be burned.
    /// @param amount The amount of tokens to burn.
    function burn(address sender, uint256 amount) external onlyCustodian {
        require(sender != address(0), "Invalid sender address");
        require(balanceOf[sender] >= amount, "Insufficient balance");
        balanceOf[sender] = balanceOf[sender].sub(amount);
        totalSupply = totalSupply.sub(amount);
        emit Burn(sender, amount);
        emit Transfer(sender, address(0), amount);
    }

    /// @notice Transfer tokens to another address.
    /// @dev Standard ERC20 transfer function.
    /// @param to The address to transfer to.
    /// @param amount The amount to be transferred.
    /// @return success True if the transfer was successful.
    function transfer(address to, uint256 amount) external override returns (bool) {
        require(to != address(0), "Invalid recipient address");
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount);
        balanceOf[to] = balanceOf[to].add(amount);
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    /// @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
    /// @dev Standard ERC20 approve function.
    /// @param spender The address which will spend the funds.
    /// @param amount The amount of tokens to be spent.
    /// @return success True if the approval was successful.
    function approve(address spender, uint256 amount) external override returns (bool) {
        require(spender != address(0), "Invalid spender address");
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /// @notice Transfer tokens from one address to another.
    /// @dev Standard ERC20 transferFrom function.
    /// @param from The address which you want to send tokens from.
    /// @param to The address which you want to transfer to.
    /// @param amount The amount of tokens to be transferred.
    /// @return success True if the transfer was successful.
    function transferFrom(address from, address to, uint256 amount) external override returns (bool) {
        require(from != address(0), "Invalid sender address");
        require(to != address(0), "Invalid recipient address");
        require(balanceOf[from] >= amount, "Insufficient balance");
        require(allowance[from][msg.sender] >= amount, "Allowance exceeded");

        balanceOf[from] = balanceOf[from].sub(amount);
        balanceOf[to] = balanceOf[to].add(amount);
        allowance[from][msg.sender] = allowance[from][msg.sender].sub(amount);
        emit Transfer(from, to, amount);
        return true;
    }
}
