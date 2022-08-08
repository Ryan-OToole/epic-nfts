const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log('Contract deployed to:', nftContract.address);

    let txn = await nftContract.makeAnEpicNFT();
    await txn.wait();
    console.log("Minted NFT from deploy I am a bad man");
    let txn2 = await nftContract.makeAnEpicNFT();
    await txn2.wait();
    console.log("Minted NFT from deploy I am a badder man");
}
const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (e) {
        console.log(e);
        process.exit(1);
    }
};
runMain();