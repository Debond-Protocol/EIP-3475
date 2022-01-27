const { expect } = require("chai");
const { ethers } = require("hardhat");

// defining an demo instantiation parameters. 
const [dev_address] = ethers.getSigners();
// details to be changed based on the EIP standard details 
const initFibonacciEpoch = 8;
const initgenesisEpoch = 0;
const initgenesisNonce = 0;
const symbolName = "SASH-USD Bond"
describe("TestBond" , function (dev_address) {
   
   before('initialisation of artifacts' , function () {
    const TestBond = await ethers.getContractFactory("TestBond");
    const TestBank = await ethers.getContractFactory("TestBank");
    const TestToken = await ethers.getContractFactory("TestToken");
    const BankContractAddress = await (TestBank.deploy()).address;
    
    // now building the deploying contracts
    const TestBondDeploy = TestBond.deploy(symbolName ,initFibonacciEpoch , initgenesisEpoch , initgenesisNonce );
    const  TestTokenDeploy = TestToken.deploy();
});
    it("is initialised" , async function () {
        
        
        expect(await TestBondDeploy.address).is.not(null);
    });

    it("calls setContract function successfully ", function () {
      
        const ExampleClass = '0'; 
        expect(TestBondDeploy.setContract(ExampleClass  , await TestBankDeploy.address )).to.be(true);
    });


    it("issueBond runs successfully" , function() {
    



    });




});