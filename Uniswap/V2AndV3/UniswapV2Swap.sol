// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;

import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IERC20.sol";

contract UniswapV2Swap {
    IUniswapV2Router02 public uniswapV2Router;
    address private constant UNISWAP_V2_ROUTER = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f; // Replace with your Uniswap V2 Router address

    /**
     * @dev Constructor initializes the Uniswap V2 Router.
     */
    constructor() {
        uniswapV2Router = IUniswapV2Router02(UNISWAP_V2_ROUTER);
    }

    /**
     * @dev Swap tokens on Uniswap V2.
     * @param tokenIn Address of the input token.
     * @param tokenOut Address of the output token.
     * @param amountIn Amount of input tokens to swap.
     * @param amountOutMin Minimum amount of output tokens to receive.
     * @param to Address to receive the output tokens.
     * @param deadline Unix timestamp after which the transaction will revert.
     */
    function swapTokensForTokens(
        address tokenIn,
        address tokenOut,
        uint256 amountIn,
        uint256 amountOutMin,
        address to,
        uint256 deadline
    ) external {
        // Transfer `amountIn` of `tokenIn` from the caller to this contract
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        // Approve the Uniswap V2 Router to spend `amountIn` of `tokenIn`
        IERC20(tokenIn).approve(address(uniswapV2Router), amountIn);

        // Define the path for the swap: from `tokenIn` to `tokenOut`
        address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;

        // Execute the swap on Uniswap V2 Router
        uniswapV2Router.swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            to,
            deadline
        );
    }
}
/*
### Explanation:
1. **Dependencies**: 
    - The contract imports `IUniswapV2Router02` and `IERC20` interfaces from Uniswap V2 Periphery.

2. **Router Address**:
    - The contract sets the address of the Uniswap V2 Router. 
    You need to replace `0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f` with the actual Uniswap V2 Router address 
    on the network you're deploying to.

3. **Constructor**:
    - Initializes the `uniswapV2Router` with the Uniswap V2 Router address.

4. **swapTokensForTokens**:
    - Transfers `amountIn` of `tokenIn` from the caller to the contract.
    - Approves the Uniswap router to spend `amountIn` of `tokenIn`.
    - Defines the path for the swap (`tokenIn` to `tokenOut`).
    - Calls `swapExactTokensForTokens` on the Uniswap V2 Router to execute the swap.

### Note:
- Make sure to adjust the router address according to the network you are using (e.g., Mainnet, Ropsten, etc.).
- You might need to update the Solidity version (`pragma solidity ^0.8.0;`) to match the version compatible 
    with your development environment and Uniswap contracts.
- Test the contract thoroughly in a development environment before deploying it to a live network.
*/
