# SwapApp 🔄

A highly optimized smart contract for swapping ERC20 tokens using the Uniswap V2 Router. Built with Solidity and [Foundry](https://getfoundry.sh/), and thoroughly tested on an Arbitrum Mainnet fork.

## Features ✨
- **Token Swapping**: Seamlessly swap exact amounts of input tokens for a minimum amount of output tokens to protect against slippage.
- **Safe Transfers**: Utilizes OpenZeppelin's `SafeERC20` (`safeTransferFrom`, `forceApprove`) to securely handle tokens that don't strictly adhere to the standard ERC20 implementation (e.g., USDT).
- **Gas Optimized**: 
  - Declares the Uniswap Router address as `immutable` to avoid expensive storage reads.
  - Replaces traditional string require messages with Custom Errors (`ZeroAmount`, `InvalidPath`) to significantly reduce deployment and runtime gas costs.
- **Standardized Integration**: Interfaces directly with the standard `IV2Router02`.

## Prerequisites 📋
- [Foundry](https://book.getfoundry.sh/getting-started/installation) installed on your machine.
- An Arbitrum Mainnet RPC URL (Alchemy, Infura, or public) for testing.

## Setup & Installation 🛠️

1. Clone the repository:
```bash
git clone [https://github.com/your-username/SWAP-APP.git](https://github.com/your-username/SWAP-APP.git)
cd SWAP-APP
```

2. Install dependencies (OpenZeppelin contracts):
```bash
forge install OpenZeppelin/openzeppelin-contracts --no-commit
```

3. Build the project:
```bash
forge build
```

## Testing 🧪
The test suite (`SwapAppTest.sol`) interacts with real mainnet liquidity pools. It impersonates a whale account to execute live token swaps (USDT to DAI) and verifies Custom Error reverts. 

Because it uses real Arbitrum addresses, **you must run the tests on an Arbitrum Mainnet fork**.

Execute the following command, replacing `<YOUR_ARBITRUM_RPC_URL>` with your actual RPC endpoint:

```bash
forge test --fork-url <YOUR_ARBITRUM_RPC_URL>
```

To see detailed execution traces (useful for debugging balances and gas values):
```bash
forge test --fork-url <YOUR_ARBITRUM_RPC_URL> -vvvv
```

## Smart Contract Architecture 🏗️
### `SwapApp.sol`
- `constructor(address _v2Router02)`: Initializes the immutable state variable with the target Dex Router.
- `swapTokens(uint256 amountIn, uint256 amountOutMin, address[] memory path, uint256 deadline)`: Pulls funds from the user, approves the router, and executes the exact input swap.

## License 📄
This project is licensed under the MIT License.