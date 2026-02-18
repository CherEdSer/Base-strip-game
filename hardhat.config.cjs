require("@nomicfoundation/hardhat-toolbox");
require("dotenv/config");

const PRIVATE_KEY = process.env.PRIVATE_KEY || "";
const BASE_RPC_URL = process.env.BASE_RPC_URL || "https://mainnet.base.org";
const BASE_SEPOLIA_RPC_URL = process.env.BASE_SEPOLIA_RPC_URL || "https://sepolia.base.org";

/** @type {import('hardhat/config').HardhatUserConfig} */
module.exports = {
  solidity: {
    version: "0.8.23",
    settings: { optimizer: { enabled: true, runs: 200 } },
  },
  networks: {
    base: { url: BASE_RPC_URL, accounts: PRIVATE_KEY ? [PRIVATE_KEY] : [], chainId: 8453 },
    baseSepolia: { url: BASE_SEPOLIA_RPC_URL, accounts: PRIVATE_KEY ? [PRIVATE_KEY] : [], chainId: 84532 },
  },
};

