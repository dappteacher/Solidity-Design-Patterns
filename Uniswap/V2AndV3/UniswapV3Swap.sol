// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract UniswapV3Swap {
    ISwapRouter public immutable swapRouter;

    constructor(ISwapRouter _swapRouter) {
        swapRouter = _swapRouter;
    }

    function swapExactInputSingle(
        address tokenIn,
        address tokenOut,
        uint24 fee,
        uint256 amountIn,
        uint256 amountOutMinimum,
        address recipient,
        uint256 deadline
    ) external returns (uint256 amountOut) {
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        IERC20(tokenIn).approve(address(swapRouter), amountIn);

        ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                fee: fee,
                recipient: recipient,
                deadline: deadline,
                amountIn: amountIn,
                amountOutMinimum: amountOutMinimum,
                sqrtPriceLimitX96: 0
            });

        amountOut = swapRouter.exactInputSingle(params);
    }

    function swapExactOutputSingle(
        address tokenIn,
        address tokenOut,
        uint24 fee,
        uint256 amountOut,
        uint256 amountInMaximum,
        address recipient,
        uint256 deadline
    ) external returns (uint256 amountIn) {
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountInMaximum);
        IERC20(tokenIn).approve(address(swapRouter), amountInMaximum);

        ISwapRouter.ExactOutputSingleParams memory params =
            ISwapRouter.ExactOutputSingleParams({
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                fee: fee,
                recipient: recipient,
                deadline: deadline,
                amountOut: amountOut,
                amountInMaximum: amountInMaximum,
                sqrtPriceLimitX96: 0
            });

        amountIn = swapRouter.exactOutputSingle(params);

        if (amountIn < amountInMaximum) {
            IERC20(tokenIn).approve(address(swapRouter), 0);
            IERC20(tokenIn).transfer(msg.sender, amountInMaximum - amountIn);
        }
    }
}

/*

### Explanation:

1. **Dependencies**:
    - The contract imports `ISwapRouter` from Uniswap V3 Periphery and `IERC20` from OpenZeppelin.

2. **Constructor**:
    - Initializes the `swapRouter` with the Uniswap V3 Router address passed as a parameter.

3. **swapExactInputSingle**:
    - Transfers `amountIn` of `tokenIn` from the caller to the contract.
    - Approves the Uniswap router to spend `amountIn` of `tokenIn`.
    - Sets up the swap parameters including the token addresses, fee, recipient, deadline, input amount, 
        minimum output amount, and price limit.
    - Calls `exactInputSingle` on the Uniswap V3 Router to execute the swap.

4. **swapExactOutputSingle**:
    - Transfers `amountInMaximum` of `tokenIn` from the caller to the contract.
    - Approves the Uniswap router to spend `amountInMaximum` of `tokenIn`.
    - Sets up the swap parameters including the token addresses, fee, recipient, deadline, output amount, 
        maximum input amount, and price limit.
    - Calls `exactOutputSingle` on the Uniswap V3 Router to execute the swap.
    - Refunds any excess `tokenIn` to the caller if the actual input amount is less than `amountInMaximum`.

### Note:
- Ensure that you replace the constructor parameter `_swapRouter` with the actual Uniswap V3 Router address 
    for the network you are deploying to.
- Make sure to test the contract thoroughly in a development environment before deploying it to a live network.
- Adjust the Solidity version (`pragma solidity ^0.8.0;`) if necessary to match your development environment and dependencies.
*/
