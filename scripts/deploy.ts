const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const MyContract = await ethers.getContractFactory("RunToEarnToken");
  const contract = await MyContract.deploy(deployer.address);

  console.log("Contract deployed to address:", contract.target);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });