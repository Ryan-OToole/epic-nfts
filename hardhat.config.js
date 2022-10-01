require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-chai-matchers");
require("dotenv").config({ path: ".env" });

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.1",
  networks: {
    goerli: {
      url: process.env.INFURA_API_GOERLI,
      accounts: [process.env.METAMASK_KEY_GOERLI]
    }
  },
};
