const { contract, accounts } = require('@openzeppelin/test-environment');
const assert = require('assert');
const { ether, constants, expectEvent } = require('@openzeppelin/test-helpers');
const TestBankContract = contract.fromArtifact("TestBank");
const TestBondContract = contract.fromArtifact("TestBond");
const TestTokenContract = contract.fromArtifact("TestToken");
const TestTokenaContract = contract.fromArtifact("TestTokena");
//TestBank test script
[owner, sender, receiver, token_contract_address, bond_contract_address] = accounts;
describe("bankContract", function () {
    it('migrateContract', async function () {
        //部署合约
        TestBankInstance = await TestBankContract.new( { from: owner });
        TestBondInstance = await TestBondContract.new( { from: owner });
        TestTokenInstance = await TestTokenContract.new("test","ts",18, { from: owner });
        ERC20FixedSupplyInstance = await TestTokenaContract.new("atest","tss",18, { from: owner });
    });
    //test setContract function
    it('setContract', async function () {
        //call setContract()
        await TestBankInstance.setContract(0,TestTokenInstance.address,TestBondInstance.address, { from: owner });
        //check if the contract address is correct
        assert.equal(TestBondInstance.address, await TestBankInstance.bond_contract());
    });
    //test buyBond function
    it('buyBond', async function () {
        //mint test input token for address
        await ERC20FixedSupplyInstance.setContract(owner,{from:owner});
        await ERC20FixedSupplyInstance.mint(owner,1000,{from:owner});
        //call approve function to give allowance
        await ERC20FixedSupplyInstance.approve(TestBankInstance.address,1000,{from:owner});
        //call buyBond function which uses test input token to buy bond 
        await TestBankInstance.buyBond(ERC20FixedSupplyInstance.address,owner,100,{from:owner});
        //check if the new balance is correct
        const tokenA= await ERC20FixedSupplyInstance.balanceOf(owner,{from:owner});
        assert.equal(900, tokenA);
        
        //check last bond nonce of the class
        const nonce= await TestBondInstance.last_bond_nonce(0);
        //check bond balance of a bond nonce
        const tokenB= await TestBondInstance.balanceOf(owner,0,nonce,{from:owner});
        console.log(tokenB.toString());
        //check the total balance 
        assert.equal(78, tokenB);
    });
    //test redeemBond function
    it('redeemBond', async function () {
        //wait
        const sleep = (timeountMS) => new Promise((resolve) => {
            setTimeout(resolve, timeountMS);
        });
        await sleep(1000);
        //set bank address in the bond contract
        await TestBondInstance.setBond(0,TestBankInstance.address,{from:owner});
        //read all nonce under a class
        const nonceList= await TestBondInstance.getNonceCreated(0);
        //read the balance of all the nonces
        const amountList=[];
        var amountA;
        for(var i=0;i<nonceList.length;i++){
            const unitAmount= await TestBondInstance.balanceOf(owner,0,nonceList[i],{from:owner});
            if(i==0){
                amountA=unitAmount;
                amountList.push(unitAmount);
            }
        }
        //set bank address for TestTokenInstance contract
        await TestTokenInstance.setContract(TestBankInstance.address,{from:owner});
        //call redeemBond function to redeem the nonce0 bond, get the reward
        await TestBankInstance.redeemBond(owner,owner,0,[nonceList[0]],amountList,{from:owner});
        //get the balance of class0 nonceList[0] 
        const amountB=await TestBondInstance.balanceOf(owner,0,nonceList[0],{from:owner});
        //check if the bond is gone from the address
        assert.equal(0, amountB);
        //get the balance of the reward token
        const tokenC= await TestTokenInstance.balanceOf(owner,{from:owner});
        //check if the reward token correspond with the bond redeemed
        assert.equal(amountA.toString(), tokenC);
    });
});
//TestToken contract test script
describe("TestToken", function () {
    it('setContract', async function () {
        //set bank contract address for TestTokenInstance
        await TestTokenInstance.setContract(TestBankInstance.address,{from:owner});
        assert.equal(TestBankInstance.address, await TestTokenInstance.bank_contract());
    });
    it('mint', async function () {
        //set bank contract address for TestTokenInstance
        await TestTokenInstance.setContract(owner,{from:owner});
        //mint token to address
        const nub=  await TestTokenInstance.mint(owner,1000,{from:owner});
        //check if the balance is correct, earlier test minted 2， now mint 1000. there should be in total 1002 token minted
        assert.equal(1002,await TestTokenInstance.balanceOf(owner,{from:owner}));
    });
});

//TestBond (ERC659) contract test script
describe("TestBond", function () {
    it('setBond', async function () {
        //set bank contract address for TestBondInstance
        await TestBondInstance.setBond(0,TestBankInstance.address,{from:owner});
    });
    it('getNonceCreated', async function () {
        //get all the nonces of a class
        const nonceList= await TestBondInstance.getNonceCreated(0);
        console.log(nonceList.toString());
    });
    it('createBondClass', async function () {
        //create a new class
        const newClass= await TestBondInstance.createBondClass(1,TestBankInstance.address,"test",8,1,{from:owner});
        console.log(newClass.toString());
    });
    it('totalSupply', async function () {
        //get the total supply
        const supply= await TestBondInstance.totalSupply(0,1,{from:owner});
        console.log(supply.toString());
    });
    it('activeSupply', async function () {
        //get activeSupply
        const supply= await TestBondInstance.activeSupply(0,1,{from:owner});
        console.log(supply.toString());
    });
    it('burnedSupply', async function () {
        //get burnedSupply
        const supply= await TestBondInstance.burnedSupply(0,1,{from:owner});
        console.log(supply.toString());
    });
    it('redeemedSupply', async function () {
        //get redeemedSupply
        const supply= await TestBondInstance.redeemedSupply(0,1,{from:owner});
        console.log(supply.toString());
    });
    it('getBondSymbol', async function () {
        //getBondSymbol
        const symbol= await TestBondInstance.getBondSymbol(1,{from:owner});
        console.log(symbol.toString());
    });
    it('getBondInfo', async function () {
        //getBondInfo
        const info= await TestBondInstance.getBondInfo(0,1,{from:owner});
        console.log(JSON.stringify(info));
    });
    it('bondIsRedeemable', async function () {
        //check if the class nonce bond is redeemable
        const bool= await TestBondInstance.bondIsRedeemable(0,1,{from:owner});
        //true if the bond is redeemable
        assert.equal(true, bool);
    });
    it('issueBond', async function () {
        //ERC659 issueBond function calls testBank _issueBond
        const bool= await TestBondInstance.issueBond(owner,1,200,{from:owner});
        //get all the nonce of a class
        const nonceList= await TestBondInstance.getNonceCreated(1);
        //check if new nonce are created
        console.log(nonceList.toString());
    });
    it('redeemBond', async function () {
        //redeemBond  call bondIsRedeemable to check if the bond is redeemable and call _redeemBond to redeem
        const sleep = (timeountMS) => new Promise((resolve) => {
            setTimeout(resolve, timeountMS);
        });
        await sleep(1500);
//amount=2
        const amountA=await TestBondInstance.balanceOf(owner,1,1,{from:owner});
        assert.equal(2, amountA);
        const bool= await TestBondInstance.redeemBond(owner,1,[1],[1],{from:owner});
        //赎回后再次查询应该是0
        const amountB=await TestBondInstance.balanceOf(owner,1,1,{from:owner});
        assert.equal(1, amountB);
    });
    it('transferBond', async function () {
        //check transferBond function
        const bool= await TestBondInstance.transferBond(owner,sender,[1],[1],[1],{from:owner});
        //check if transactions are made
        const amountB=await TestBondInstance.balanceOf(sender,1,1,{from:owner});
        //check the balances
        console.log(amountB.toString());
        assert.equal(1, amountB);
    });
    it('burnBond', async function () {
        //burn bond function
        const bool= await TestBondInstance.burnBond(sender,[1],[1],[1],{from:sender});
        //check if bond is burned
        const amountB=await TestBondInstance.balanceOf(sender,1,1,{from:owner});
        //check the balance of the address
        console.log(amountB.toString());
        assert.equal(0, amountB);
    });
});
