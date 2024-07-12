// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  
  const UsdcToken = await hre.ethers.getContractFactory("KakaoERC");
  const usdc = await UsdcToken.deploy("1000000000000000000000000");

  await usdc.deployed();

  console.log("Greeter deployed to:", usdc.address);

  await sleep(10000);

  await run("verify:verify", {
    // address: "0x010493Ff3c3CAcf62E149B8BCe80B11548696BE7",
    address: usdc.address,
    constructorArguments: ["1000000000000000000000000"] ,
    contract: "contracts/KakaoERC.sol:KakaoERC",
  })
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}


// We recommend this pattern to be able to use async/await everywhere
// 0x010493Ff3c3CAcf62E149B8BCe80B11548696BE7
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });