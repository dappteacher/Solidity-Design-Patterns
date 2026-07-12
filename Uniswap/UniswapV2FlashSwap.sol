// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher

pragma solidity ^0.8.26;

/**
 * @title IUniswapV2Callee
 * @dev Interface for Uniswap V2 Callee
 */
interface IUniswapV2Callee {
    /**
     * @notice Function to be called by Uniswap V2 pair contracts during a flash swap
     * @param sender Address of the sender
     * @param amount0 Amount of token0
     * @param amount1 Amount of token1
     * @param data Arbitrary data passed by the caller
     */
    function uniswapV2Call(
        address sender, uint256 amount0, uint256 amount1, bytes calldata data
    ) external;
}

/**
 * @title UniswapV2FlashSwap
 * @notice A contract to perform flash swaps on Uniswap V2
 * @dev Implements the IUniswapV2Callee interface
 */
contract UniswapV2FlashSwap is IUniswapV2Callee {
    address private constant UNISWAP_V2_FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    IUniswapV2Factory private constant factory = IUniswapV2Factory(UNISWAP_V2_FACTORY);
    IERC20 private constant weth = IERC20(WETH);

    IUniswapV2Pair private immutable pair;

    uint256 public amountToRepay;

    /**
     * @dev Constructor sets the Uniswap V2 pair for DAI/WETH
     */
    constructor() {
        pair = IUniswapV2Pair(factory.getPair(DAI, WETH));
    }

    /**
     * @notice Initiates a flash swap
     * @param wethAmount Amount of WETH to borrow
     */
    function flashSwap(uint256 wethAmount) external {
        bytes memory data = abi.encode(WETH, msg.sender);
        pair.swap(0, wethAmount, address(this), data);
    }

    /**
     * @notice Called by the DAI/WETH pair contract during a flash swap
     * @dev Executes custom logic and repays the loan with a fee
     * @param sender Address of the sender
     * @param amount0 Amount of token0
     * @param amount1 Amount of token1
     * @param data Arbitrary data passed by the caller
     */
    function uniswapV2Call(
        address sender, uint256 amount0, uint256 amount1, bytes calldata data
    ) external override {
        require(msg.sender == address(pair), "not pair");
        require(sender == address(this), "not sender");

        (address tokenBorrow, address caller) = abi.decode(data, (address, address));
        require(tokenBorrow == WETH, "token borrow != WETH");

        uint256 fee = (amount1 * 3) / 997 + 1;
        amountToRepay = amount1 + fee;

        weth.transferFrom(caller, address(this), fee);
        weth.transfer(address(pair), amountToRepay);
    }
}

/**
 * @title IUniswapV2Pair
 * @dev Interface for Uniswap V2 Pair
 */
interface IUniswapV2Pair {
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data
    ) external;
}

/**
 * @title IUniswapV2Factory
 * @dev Interface for Uniswap V2 Factory
 */
interface IUniswapV2Factory {
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

/**
 * @title IERC20
 * @dev Interface for ERC20 standard
 */
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

/**
 * @title IWETH
 * @dev Interface for Wrapped Ether (WETH)
 */
interface IWETH is IERC20 {
    function deposit() external payable;
    function withdraw(uint256 amount) external;
}
