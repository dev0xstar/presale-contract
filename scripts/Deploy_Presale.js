const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log(
    "Deploying contracts with the account:",
    deployer.address
  );

  const Presale = await hre.ethers.getContractFactory("Presale");
  const presale = await Presale.deploy("0xc2E29870eCFa3833bcbbEfB040507D5a4dc6Fe08");

  await presale.deployed();

  console.log("Presale deployed to:", presale.address);

  await sleep(10000);

  await run("verify:verify", {
    // address: "0xc9c3C6FE0B727BB838388bDD672f06C152E99c8f",
    address: presale.address,
    constructorArguments: ["0xc2E29870eCFa3833bcbbEfB040507D5a4dc6Fe08"] ,
    contract: "contracts/Presale.sol:Presale",
  })
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
