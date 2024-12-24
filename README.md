# RECYC Coin

RECYC Coin is a deflationary ERC20 token built on Ethereum and Binance Smart Chain (BSC). The token has a burning mechanism that reduces supply with every transaction, a fee collection mechanism to fund ecosystem development, and other features aimed at creating a sustainable digital economy.

## Features
- **Deflationary Mechanism**: 2% of each transaction is burned, reducing the total supply over time.
- **Fee Collection**: 2% of each transaction is sent to a fee collector address, which can be used for ecosystem development.
- **ERC20 & BEP20 Compatibility**: Fully compatible with Ethereum and Binance Smart Chain.
- **Minting**: The contract owner can mint new tokens up to a total supply of 1 trillion.
  
## Installation

To deploy the contract, you need to:

1. Install Truffle or Hardhat for Ethereum development.
2. Set up your environment with a wallet (e.g., MetaMask) and a test network (e.g., Rinkeby, BSC Testnet).
3. Deploy the contract to the desired blockchain (Ethereum or BSC).

## Contract Address

Once deployed, you will have the contract address for your token. Ensure you keep this address safe.

## How to use the contract
- **Burn tokens**: You can burn tokens by calling the `burn(uint256 amount)` function.
- **Mint new tokens**: The contract owner can mint new tokens with `mint(address to, uint256 amount)` function.
- **Set fee collector address**: The contract owner can change the fee collector using `setFeeCollector(address newCollector)` function.

For more details, check the contract code.

## License
This project is licensed under the MIT License.
