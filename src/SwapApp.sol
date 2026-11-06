// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IV2Router02} from "./interfaces/IV2Router02.sol";
import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

contract SwapApp {
    using SafeERC20 for IERC20;

    address public immutable v2Router02Address;

    event TokensSwapped(address indexed user, uint256 amountIn, uint256 amountOut, address[] path);

    error InvalidPath();
    error ZeroAmount();

    /// @notice Initializes the contract with the Uniswap V2 Router address
    /// @param _v2Router02 The address of the Uniswap V2 Router
    constructor(address _v2Router02) {
        v2Router02Address = _v2Router02;
    }

    /// @notice Swaps an exact amount of input tokens for a minimum amount of output tokens
    /// @dev Uses Uniswap V2 Router to execute the swap. Requires prior ERC20 approval from the user to this contract.
    /// @param amountIn The exact amount of input tokens to swap
    /// @param amountOutMin The minimum amount of output tokens to receive
    /// @param path The array of token addresses representing the swap path
    /// @param deadline The unix timestamp after which the swap will revert
    function swapTokens(uint256 amountIn, uint256 amountOutMin, address[] memory path, uint256 deadline) external {
        if (amountIn == 0) revert ZeroAmount();
        if (path.length < 2) revert InvalidPath();

        IERC20(path[0]).safeTransferFrom(msg.sender, address(this), amountIn);
        IERC20(path[0]).forceApprove(v2Router02Address, amountIn);
        
        uint[] memory amountOuts = IV2Router02(v2Router02Address).swapExactTokensForTokens(
            amountIn, 
            amountOutMin, 
            path, 
            msg.sender, 
            deadline
        );
        
        emit TokensSwapped(msg.sender, amountIn, amountOuts[amountOuts.length - 1], path);
    }
}