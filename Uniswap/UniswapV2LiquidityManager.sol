// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.26;

// Import interfaces directly from Uniswap
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@uniswap/v2-core/contracts/interfaces/IERC20.sol";

contract UniswapV2LiquidityManager {
    address private constant FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private constant ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;

    IUniswapV2Router02 public uniswapRouter;

    // Constructor to set the Uniswap router
    constructor() {
        uniswapRouter = IUniswapV2Router02(ROUTER);
    }

    /**
     * @notice Adds liquidity to the Uniswap pool for _tokenA and _tokenB
     * @param _tokenA The address of tokenA
     * @param _tokenB The address of tokenB
     * @param _amountA The amount of tokenA to add as liquidity
     * @param _amountB The amount of tokenB to add as liquidity
     */
    function addLiquidity(
        address _tokenA,
        address _tokenB,
        uint256 _amountA,
        uint256 _amountB
    ) external {
        _safeTransferFrom(IERC20(_tokenA), msg.sender, address(this), _amountA);
        _safeTransferFrom(IERC20(_tokenB), msg.sender, address(this), _amountB);

        _safeApprove(IERC20(_tokenA), ROUTER, _amountA);
        _safeApprove(IERC20(_tokenB), ROUTER, _amountB);

        uniswapRouter.addLiquidity(
            _tokenA,
            _tokenB,
            _amountA,
            _amountB,
            1, // Min amount of tokenA to add (for slippage protection)
            1, // Min amount of tokenB to add (for slippage protection)
            address(this),
            block.timestamp
        );
    }

    /**
     * @notice Removes liquidity from the Uniswap pool for _tokenA and _tokenB
     * @param _tokenA The address of tokenA
     * @param _tokenB The address of tokenB
     */
    function removeLiquidity(address _tokenA, address _tokenB) external {
        address pair = IUniswapV2Factory(FACTORY).getPair(_tokenA, _tokenB);
        require(pair != address(0), "Invalid pair address");

        uint256 liquidity = IERC20(pair).balanceOf(address(this));
        _safeApprove(IERC20(pair), ROUTER, liquidity);

        uniswapRouter.removeLiquidity(
            _tokenA,
            _tokenB,
            liquidity,
            1, // Min amount of tokenA to receive (for slippage protection)
            1, // Min amount of tokenB to receive (for slippage protection)
            address(this),
            block.timestamp
        );
    }

    /**
     * @dev Safely transfers tokens from sender to recipient
     * The transferFrom function may or may not return a bool.
     * @param token The token to transfer
     * @param sender The address of the sender
     * @param recipient The address of the recipient
     * @param amount The amount of tokens to transfer
     */
    function _safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        (bool success, bytes memory data) = address(token).call(
            abi.encodeWithSelector(token.transferFrom.selector, sender, recipient, amount)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))), "TransferFrom failed");
    }

    /**
     * @dev Safely approves tokens for spending
     * The approve function may or may not return a bool.
     * @param token The token to approve
     * @param spender The address of the spender
     * @param amount The amount of tokens to approve
     */
    function _safeApprove(IERC20 token, address spender, uint256 amount) internal {
        (bool success, bytes memory data) = address(token).call(
            abi.encodeWithSelector(token.approve.selector, spender, amount)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))), "Approve failed");
    }
}
