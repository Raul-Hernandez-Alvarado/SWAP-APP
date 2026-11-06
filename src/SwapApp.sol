// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IV2Router02} from "./interfaces/IV2Router02.sol";
import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

contract SwapApp {
    using SafeERC20 for IERC20;

    address public v2Router02Address;

    event TokensSwapped(address indexed user, uint256 amountIn, uint256 amountOut, address[] path);

    constructor(address _v2Router02) {
        v2Router02Address = _v2Router02;
    }

    function swapTokens(uint256 amountIn_, uint256 amountOutMin_, address[] memory path_, uint256 deadline_) external {
        require(path_.length >= 2, "Invalid path");
        IERC20(path_[0]).safeTransferFrom(msg.sender, address(this), amountIn_);
        IERC20(path_[0]).forceApprove(v2Router02Address, amountIn_);
        uint[] memory amountOuts = IV2Router02(v2Router02Address).swapExactTokensForTokens(amountIn_, amountOutMin_, path_, msg.sender, deadline_);
        emit TokensSwapped(msg.sender, amountIn_, amountOuts[amountOuts.length - 1], path_);
    }

}