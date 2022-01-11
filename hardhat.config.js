require("@nomiclabs/hardhat-waffle");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 module.exports = {
   solidity: '0.8.0',
   networks: {
     rinkeby: {
       url: 'https://eth-rinkeby.alchemyapi.io/v2/1aNQaznS7dnvk6AG5yJ2H141ZbbbdtPE',
       accounts: ['5a4f8255ba1224a877dc7be35f01c7cbba5736c6c7f6fb1831ffd9f45f4954b3'],
     },
   },
 };
 