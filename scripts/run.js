const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory("Elements");
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("Contract deployed to:", nftContract.address);
  
    // Call the function.
    let txn = await nftContract.BigBang();
    await txn.wait();

    txn = await nftContract.BigBang();
    await txn.wait();

    txn = await nftContract.BigBang();
    await txn.wait();
  
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();
  