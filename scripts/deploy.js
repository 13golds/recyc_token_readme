async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    const RECYC = await ethers.getContractFactory("RECYC");
    const feeCollectorAddress = "0x73731b3605a01a60308A57d4F8B0BDFfA8691eAD"; 
    const contract = await RECYC.deploy(0x73731b3605a01a60308A57d4F8B0BDFfA8691eAD);

    console.log("RECYC deployed to:", contract.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

