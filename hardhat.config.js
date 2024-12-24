require('@nomiclabs/hardhat-ethers');
require('dotenv').config();

module.exports = {
  solidity: "0.8.0",  
  networks: {
    bsc: {
      url: process.env.BSC_URL, 
      accounts: [`0x${process.env.PRIVATE_KEY}`], 
    },
  },
};
