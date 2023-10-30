async function main(){
    const ERC1155 =await ethers.getContractFactory("ERC1155Contract");
    const HardhatERC1155= await ERC1155.deploy();
    console.log("address required",await HardhatERC1155.getAddress());

}
main()
    .then(()=>process.exit(0))
    .catch((error)=>{
        console.error(error);
        process.exit(1);
    });