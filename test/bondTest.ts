import {BondInstance} from "../types/truffle-contracts";


const Bond = artifacts.require("Bond");

contract('Bond', async (accounts: string[]) => {

    let bondContract: BondInstance;
    const lender = accounts[1];
    const operator = accounts[2];
    const secondaryMarketBuyer = accounts[3];
    const secondaryMarketBuyer2 = accounts[4];
    const DBITAddress = accounts[5];
    const DAIAddress = accounts[7];
    const USDTAddress = accounts[8];
    const USDCAddress = accounts[9];

    const DBITClassId = 0
    const USDCClassId = 1
    const USDTClassId = 2
    const DAIClassId = 3

    const firstNonceId = 0;

    // it('should create new bonds (theorically only after proposal)', async () => {
    //     bondContract = await Bond.deployed();
    //     await bondContract.createBond(DBITClassId, DBITAddress,"DBIT");
    //     await bondContract.createBond(USDCClassId, USDCAddress,"USDC");
    //     await bondContract.createBond(DAIClassId, DAIAddress, "DAI");
    //     await bondContract.createBond(USDTClassId, USDTAddress, "USDT");
    //     const bonds = (await bondContract.getClasses())
    //     assert.isArray(bonds);
    // })
    //
    // it('should issue bonds to a lender ', async () => {
    //     await bondContract.issueBonds(lender, DBITClassId, firstNonceId, 7000, {from: accounts[0]})
    //     await bondContract.issueBonds(lender, DBITClassId, firstNonceId, 7000, {from: accounts[0]})
    //     const lenderNonces = (await bondContract.noncesPerAddress(lender, DBITClassId)).map(n => n.toNumber());
    //     console.log(lenderNonces);
    //     const balance = (await bondContract.balanceOf(lender, DBITClassId, firstNonceId)).toNumber()
    //     const activeSupply = (await bondContract.activeSupply(DBITClassId, firstNonceId)).toNumber()
    //     assert.equal(balance, 14000);
    //     assert.equal(activeSupply, 14000);
    // })
    // //
    // it('should be able the lender to transfer bonds to another address', async () => {
    //     await bondContract.transferFrom(lender, secondaryMarketBuyer, DBITClassId, firstNonceId, 2000, {from: lender})
    //     const lenderBalance = (await bondContract.balanceOf(lender, DBITClassId, firstNonceId)).toNumber()
    //     const secondaryBuyerBalance = (await bondContract.balanceOf(secondaryMarketBuyer, DBITClassId, firstNonceId)).toNumber()
    //     const activeSupply = (await bondContract.activeSupply(DBITClassId, firstNonceId)).toNumber()
    //     assert.equal(lenderBalance, 12000);
    //     assert.equal(secondaryBuyerBalance, 2000);
    //     assert.equal(activeSupply, 14000);
    // })
    // //
    // it('should be able to manipulate bonds after approval', async () => {
    //     await bondContract.setApprovalFor(operator, [DBITClassId], [firstNonceId], true, {from: lender})
    //     const isApproved = await bondContract.isApprovedFor(lender, operator, DBITClassId, firstNonceId);
    //     assert.isTrue(isApproved);
    //     await bondContract.transferFrom(lender, secondaryMarketBuyer2, DBITClassId, firstNonceId, 3000, {from: operator})
    //     assert.equal((await bondContract.balanceOf(lender, DBITClassId, firstNonceId)).toNumber(), 9000);
    //     assert.equal((await bondContract.balanceOf(secondaryMarketBuyer2, DBITClassId, firstNonceId)).toNumber(), 3000);
    //
    // })
    // //
    // //
    // it('should redeem bonds when conditions are met', async () => {
    //     await bondContract.redeemBonds(lender, DBITClassId, firstNonceId, 3000);
    //     assert.equal((await bondContract.balanceOf(lender, DBITClassId, firstNonceId)).toNumber(), 6000);
    // })


    //////////////////// UNIT TESTS //////////////////////////////

    it('should return the active supply', async () => {
        const activeSupply = (await bondContract.activeSupply(DBITClassId, firstNonceId)).toNumber();
        console.log(activeSupply)
        assert.isNumber(activeSupply);
    })

    it('should return the redeemed supply', async () => {
        const redeemedSupply = (await bondContract.redeemedSupply(DBITClassId, firstNonceId)).toNumber();
        console.log(redeemedSupply)
        assert.isNumber(redeemedSupply);
    })

    it('should return the burned supply', async () => {
        const burnedSupply = (await bondContract.burnedSupply(DBITClassId, firstNonceId)).toNumber();
        console.log(burnedSupply)
        assert.isNumber(burnedSupply);
    })

    it('should return the total supply', async () => {
        const totalSupply = (await bondContract.totalSupply(DBITClassId, firstNonceId)).toNumber();
        console.log(totalSupply)
        assert.isNumber(totalSupply);
    })

    it('should return the balanceOf a bond of a given address', async () => {
        const balanceOf = (await bondContract.balanceOf(lender, DBITClassId, firstNonceId)).toNumber();
        console.log(balanceOf)
        assert.isNumber(balanceOf);
    })

    it('should return the symbol of a class of bond', async () => {
        const symbol = (await bondContract.symbol(DBITClassId));
        console.log(symbol)
        assert.isString(symbol);
    })

    it('should return the infos of a class and nonce of bond', async () => {
        const infos = (await bondContract.infos(DBITClassId, firstNonceId));
        console.log(JSON.stringify(infos))
    })

    it('should return if an operator is approved on a class and nonce given for an address', async () => {
        const isApproved = (await bondContract.isApprovedFor(lender, operator, DBITClassId, firstNonceId));
        console.log("operator is Approved? : ", isApproved)
        assert.isBoolean(isApproved);
    })

    it('should return all bond classes', async () => {
        const classes = (await bondContract.getClasses()).map(c => c.toNumber());
        console.log("classes : ", classes)
        assert.isArray(classes);
    })

    it('should return all nonces for a class given', async () => {
        const nonces = (await bondContract.getNonces(DBITClassId)).map(c => c.toNumber());
        console.log("DBIT Nonces : ", nonces)
        assert.isArray(nonces);
    })

});
