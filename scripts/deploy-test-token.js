// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
    // Deploy Test Token
    const TestToken = await hre.ethers.getContractFactory("ERC20Mock");
    const testToken = await TestToken.deploy("Boka", "BOKA", ethers.utils.parseEther("100000000"));
    await testToken.deployed();
    console.log("BokaToken deployed to:", testToken.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
