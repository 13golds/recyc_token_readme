async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const RecycToken = await ethers.getContractFactory("RecycToken");
  const recycToken = await RecycToken.deploy();
  console.log("RecycToken deployed to:", recycToken.0x5462f09252a86ECEcefd35Ab974E61943530593D);


  await recycToken.setTransactionFee(1);
  console.log("Transaction Fee set to:", await recycToken.transactionFeePercentage());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
