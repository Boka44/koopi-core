// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const ethers = require("ethers");

async function main() {
    const signers = await hre.ethers.getSigners();
    const owner = await signers[0];

    const gasToken = "0xfFf9976782d46CC05630D1f6eBAb18b2324d6B14";

    // Deploy Test Token
    const TestToken = await hre.ethers.getContractFactory("RevShare");
    const testToken = await TestToken.connect(owner).deploy(gasToken);
    // await testToken.deployed();
    console.log("RevShare contract deployed to:", await testToken.getAddress());
}
 
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
