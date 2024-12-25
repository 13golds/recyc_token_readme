# RECYC Coin

RECYC Coin is a deflationary BEP20 token built on Binance Smart Chain (BSC). The token is designed to support eco-friendly initiatives by promoting sustainability through tokenomics.

## Features
- **Deflationary Mechanism**: A transaction fee ranging from 0.5% to 5% is applied, with a portion burned to reduce total supply over time.
- **Fee Collection**: A percentage of the transaction fee is directed to a designated wallet to fund ecosystem and environmental projects.
- **Total Supply**: 1 billion RECYC tokens.
- **Blockchain Compatibility**: Built on Binance Smart Chain (BSC) for fast and low-cost transactions.

## Installation

To deploy or interact with the contract, follow these steps:

1. Clone the repository:
   ```bash
   git clone <repository-link>
   cd <repository-folder>
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Set up your environment:
   - Create a `.env` file in the root directory.
   - Add the following variables:
     ```env
     PRIVATE_KEY=<your_private_key>
     BSC_RPC_URL=<your_bsc_rpc_url>
     ```
4. Compile the smart contracts:
   ```bash
   npx hardhat compile
   ```
5. Deploy the contract to Binance Smart Chain:
   ```bash
   npx hardhat run scripts/deploy.js --network bsc
   ```

## Contract Address

- **RECYC Token Address**: `0x5462f09252a86ECEcefd35Ab974E61943530593D`

## How to use the contract

- **Transfer Tokens**: Use the `transfer(address recipient, uint256 amount)` function.
- **Burn Tokens**: Call the `burn(uint256 amount)` function to reduce the supply.
- **Fee Adjustments**: Transaction fees are dynamically set within the 0.5% to 5% range.

## Contacts

For inquiries and support, please reach out via email:
- **Email**: [aigolds@proton.me](mailto:aigolds@proton.me)

## License

This project is licensed under the MIT License.

