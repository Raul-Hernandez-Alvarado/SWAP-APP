// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {SwapApp} from "../src/SwapApp.sol";
import {Test} from "forge-std/Test.sol";
import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract SwapAppTest is Test {

    SwapApp app;
    address uniswapV2Router02Address = 0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24;
    address user = 0x2a36459aB9AfD643D5cde84910B1fC9B6be6497c; // Address with USDT in arbitrum mainnet 
    address usdtAddress = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9; // USDT token address in arbitrum mainnet
    address daiAddress = 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1; // DAI token address in arbitrum mainnet

    function setUp() public {
        app = new SwapApp(uniswapV2Router02Address);
    }

    function testHasBeanDeployedCorrectly() public view {
        assertEq(app.v2Router02Address(), uniswapV2Router02Address);
    }

    function testSwapTokensCorrectly() public {
        vm.startPrank(user);
        uint256 amountIn = 5* 1e6; // 5 USDT with 6 decimals
        IERC20(usdtAddress).approve(address(app), amountIn);
        uint256 amountOutMin = 4 * 1e18; // Set a minimum amount out to avoid slippage issues
        uint256 deadline = 1738499328 + 100000000000; // Set a deadline far in the future to avoid transaction expiration

        address[] memory path = new address[](2);
        path[0] = usdtAddress; // USDT
        path[1] = daiAddress; // DAI

        uint256 usdtBalanceBefore = IERC20(usdtAddress).balanceOf(user);
        uint256 daiBalanceBefore = IERC20(daiAddress).balanceOf(user);
        app.swapTokens(amountIn, amountOutMin, path, deadline);
        uint256 usdtBalanceAfter = IERC20(usdtAddress).balanceOf(user);
        uint256 daiBalanceAfter = IERC20(daiAddress).balanceOf(user);

        assertEq(usdtBalanceAfter, usdtBalanceBefore - amountIn);
        assertGt(daiBalanceAfter, daiBalanceBefore);

        vm.stopPrank();
    }

}
