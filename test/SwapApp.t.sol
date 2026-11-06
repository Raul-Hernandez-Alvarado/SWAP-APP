// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {SwapApp} from "../src/SwapApp.sol";
import {Test} from "forge-std/Test.sol";
import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

/**
 * @title SwapAppTest
 * @notice Test suite for the SwapApp contract running on an Arbitrum fork
 */
contract SwapAppTest is Test {

    SwapApp app;
    
    address constant UNISWAP_V2_ROUTER = 0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24;
    address constant WHALE = 0x2a36459aB9AfD643D5cde84910B1fC9B6be6497c; // Address with USDT in arbitrum mainnet 
    address constant USDT = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9; // USDT token address in arbitrum mainnet
    address constant DAI = 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1; // DAI token address in arbitrum mainnet

    function setUp() public {
        app = new SwapApp(UNISWAP_V2_ROUTER);
    }

    /**
     * @notice Verifies that the contract is deployed with the correct Router address
     */
    function testHasBeenDeployedCorrectly() public view {
        assertEq(app.v2Router02Address(), UNISWAP_V2_ROUTER);
    }

    /**
     * @notice Ensures the transaction reverts if the user tries to swap 0 tokens
     */
    function testRevertIfAmountInIsZero() public {
        address[] memory path = new address[](2);
        path[0] = USDT;
        path[1] = DAI;

        vm.expectRevert(SwapApp.ZeroAmount.selector);
        app.swapTokens(0, 1 ether, path, block.timestamp + 1000);
    }

    /**
     * @notice Ensures the transaction reverts if the routing path has fewer than 2 addresses
     */
    function testRevertIfPathIsInvalid() public {
        address[] memory path = new address[](1);
        path[0] = USDT;

        vm.expectRevert(SwapApp.InvalidPath.selector);
        app.swapTokens(1e6, 1 ether, path, block.timestamp + 1000);
    }

    /**
     * @notice Tests a successful swap from USDT to DAI impersonating a whale account
     */
    function testSwapTokensCorrectly() public {
        vm.startPrank(WHALE);
        
        uint256 amountIn = 5 * 1e6; // 5 USDT with 6 decimals
        IERC20(USDT).approve(address(app), amountIn);
        
        uint256 amountOutMin = 4 * 1e18; // Set a minimum amount out to avoid slippage issues
        uint256 deadline = block.timestamp + 1000; // Use current block timestamp

        address[] memory path = new address[](2);
        path[0] = USDT; 
        path[1] = DAI; 

        uint256 usdtBalanceBefore = IERC20(USDT).balanceOf(WHALE);
        uint256 daiBalanceBefore = IERC20(DAI).balanceOf(WHALE);
        
        app.swapTokens(amountIn, amountOutMin, path, deadline);
        
        uint256 usdtBalanceAfter = IERC20(USDT).balanceOf(WHALE);
        uint256 daiBalanceAfter = IERC20(DAI).balanceOf(WHALE);

        assertEq(usdtBalanceAfter, usdtBalanceBefore - amountIn);
        assertGt(daiBalanceAfter, daiBalanceBefore);

        vm.stopPrank();
    }
}