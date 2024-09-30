import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";
dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks: {
   
    scrollSepolia: {
      url: `https://scroll-sepolia.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY}`,
      accounts: [`0x${process.env.ACCOUNT_PRIVATE_KEY!}`],
    },
  },
  
  etherscan: {
    apiKey: {
      scrollSepolia: process.env.ETHERSCAN_API_KEY!,
    },
    customChains: [
      {
        network: 'scrollSepolia',
        chainId: 534351,
        urls: {
          apiURL: 'https://api-sepolia.scrollscan.com/api',
          browserURL: 'https://sepolia.scrollscan.com/',
        },
      },
    ],
  },

};

export default config;