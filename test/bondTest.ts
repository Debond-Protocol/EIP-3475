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

    let firstNonceId: number;

    const dateNow = Date.now();

    it('should create new bonds ', async () => {
        bondContract = await Bond.deployed();
        await bondContract.createBond(DBITClassId, DBITAddress,"DBIT");
        await bondContract.createBond(USDCClassId, USDCAddress,"USDC");
        await bondContract.createBond(DAIClassId, DAIAddress, "DAI");
        await bondContract.createBond(USDTClassId, USDTAddress, "USDT");
        const bonds = (await bondContract.getClasses())
        console.log(bonds)
        assert.isArray(bonds);
    })

    it('should issue bonds to a lender ', async () => {
        await bondContract.issue(lender, DBITClassId, dateNow, dateNow + 120 * 24 * 3600, 7000, {from: accounts[0]})
        await bondContract.issue(lender, DBITClassId, dateNow, dateNow + 120 * 24 * 3600, 7000, {from: accounts[0]})
        const nonceIds = (await bondContract.getNonces(DBITClassId)).map(n => n.toNumber())
        firstNonceId = nonceIds[0];
        const lenderNonces = await bondContract.getBonds(lender, DBITClassId);
        console.log(lenderNonces);
        const balance = (await bondContract.balanceOf(lender, DBITClassId, firstNonceId)).toNumber()
        const activeSupply = (await bondContract.activeSupply(DBITClassId, firstNonceId)).toNumber()
        assert.equal(balance, 14000);
        assert.equal(activeSupply, 14000);
    })
    //
    it('should be able the lender to transfer bonds to another address', async () => {
        await bondContract.transferFrom(lender, secondaryMarketBuyer, DBITClassId, firstNonceId, 2000, {from: lender})
        const lenderBalance = (await bondContract.balanceOf(lender, DBITClassId, firstNonceId)).toNumber()
        const secondaryBuyerBalance = (await bondContract.balanceOf(secondaryMarketBuyer, DBITClassId, firstNonceId)).toNumber()
        const activeSupply = (await bondContract.activeSupply(DBITClassId, firstNonceId)).toNumber()
        assert.equal(lenderBalance, 12000);
        assert.equal(secondaryBuyerBalance, 2000);
        assert.equal(activeSupply, 14000);
    })
    //
    it('should be able to manipulate bonds after approval', async () => {
        await bondContract.setApprovalFor(operator, [DBITClassId], [firstNonceId], true, {from: lender})
        const isApproved = await bondContract.isApprovedFor(lender, operator, DBITClassId, firstNonceId);
        assert.isTrue(isApproved);
        await bondContract.transferFrom(lender, secondaryMarketBuyer2, DBITClassId, firstNonceId, 3000, {from: operator})
        assert.equal((await bondContract.balanceOf(lender, DBITClassId, firstNonceId)).toNumber(), 9000);
        assert.equal((await bondContract.balanceOf(secondaryMarketBuyer2, DBITClassId, firstNonceId)).toNumber(), 3000);

    })
    //
    // it('should burn supply of the bond', async () => {
    //     await bondContract.redeem(lender, 0, 0, 2000);
    //     await bondContract.redeemedSupply(0, 0);
    // })
    //
    // it('should redeem bonds when conditions are met', async () => {
    //
    // })


});
