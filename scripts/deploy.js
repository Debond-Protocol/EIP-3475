// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const [hre, ethers] = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const Bond = await hre.ethers.getContractFactory("TestBond");
  const Bank = await hre.ethers.getContractFactory("TestBank");
  const Token = await hre.ethers.getContractFactory("TestToken");
  const [Deployer, BankAdmin] =  ethers.getSigners();
  
  const BondDeploy = await Bond.deploy(Deployer);
  const BankDeploy = await Bank.deploy(BankAdmin);
  const TokenDeploy = await Token.deploy(Deployer);

  await BondDeploy.deployed();

  console.log("contracts are deployed successfully on following:", BondDeploy.address, BankDeploy.address,TokenDeploy.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
