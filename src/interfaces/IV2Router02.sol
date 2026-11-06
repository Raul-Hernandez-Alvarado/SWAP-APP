// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IV2Router02
 * @notice Interface for the Uniswap V2 Router
 */
interface IV2Router02 {
    
    /**
     * @notice Swaps an exact amount of input tokens for as many output tokens as possible
     * @param amountIn The amount of input tokens to send
     * @param amountOutMin The minimum amount of output tokens that must be received for the transaction not to revert
     * @param path An array of token addresses representing the routing path
     * @param to The address of the recipient of the output tokens
     * @param deadline The unix timestamp after which the transaction will revert
     * @return amounts The input token amount and all subsequent output token amounts
     */
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}