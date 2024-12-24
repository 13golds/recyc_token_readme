require('@nomiclabs/hardhat-ethers');
require('dotenv').config();

module.exports = {
  solidity: "0.8.0",  // Версия Solidity
  networks: {
    bsc: {
      url: process.env.BSC_URL, // URL для BSC
      accounts: [`0x${process.env.PRIVATE_KEY}`], // Ваш приватный ключ из .env
    },
  },
};
