/** @type import('hardhat/config').HardhatUserConfig */

require("dotenv").config();
require("@nomicfoundation/hardhat-verify");
require("@nomicfoundation/hardhat-ethers");
const { API_URL, PRIVATE_KEY } = process.env;
module.exports = {
 solidity: "0.8.20",
 defaultNetwork: "sepolia",
 networks: {
   hardhat: {},
   sepolia: {
     url: API_URL,
     accounts: [`0x${PRIVATE_KEY}`],
   },
 },
 etherscan: {
  apiKey: "J7JGH9DWZ72U8AZ75RHWQGDC5ERIFFC7AI",
},
};
