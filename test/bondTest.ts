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

    let firstBondId: string
    let firstNonceId: string

    const dateNow = Date.now();

    it('should create new bonds ', async () => {
        bondContract = await Bond.deployed();
        await bondContract.createBond(USDTAddress, DBITAddress,"DBIT-USDT");
        await bondContract.createBond(USDCAddress, DBITAddress,"DBIT-USDC");
        await bondContract.createBond(DAIAddress, DBITAddress, "DBIT-DAI");
        const bonds = (await bondContract.getClasses())
        firstBondId = bonds[0];
        console.log(bonds)
        assert.isArray(bonds);
    })

    it('should issue bonds to a lender ', async () => {
        await bondContract.issue(lender, firstBondId, dateNow, dateNow + 120 * 24 * 3600, 7000, {from: accounts[0]})
        await bondContract.issue(lender, firstBondId, dateNow, dateNow + 120 * 24 * 3600, 7000, {from: accounts[0]})
        const nonceIds = await bondContract.getNonces(firstBondId)
        firstNonceId = nonceIds[0];
        const lenderNonces = await bondContract.getBonds(lender, firstBondId);
        const balance = (await bondContract.balanceOf(lender, firstBondId, firstNonceId)).toNumber()
        const activeSupply = (await bondContract.activeSupply(firstBondId, firstNonceId)).toNumber()
        assert.equal(balance, 14000);
        assert.equal(activeSupply, 14000);
    })
    //
    it('should be able the lender to transfer bonds to another address', async () => {
        await bondContract.transferFrom(lender, secondaryMarketBuyer, firstBondId, firstNonceId, 2000, {from: lender})
        const lenderBalance = (await bondContract.balanceOf(lender, firstBondId, firstNonceId)).toNumber()
        const secondaryBuyerBalance = (await bondContract.balanceOf(secondaryMarketBuyer, firstBondId, firstNonceId)).toNumber()
        const activeSupply = (await bondContract.activeSupply(firstBondId, firstNonceId)).toNumber()
        assert.equal(lenderBalance, 12000);
        assert.equal(secondaryBuyerBalance, 2000);
        assert.equal(activeSupply, 14000);
    })
    //
    it('should be able to manipulate bonds after approval', async () => {
        await bondContract.setApprovalFor(operator, [firstBondId], [firstNonceId], true, {from: lender})
        const isApproved = await bondContract.isApprovedFor(lender, operator, firstBondId, firstNonceId);
        assert.isTrue(isApproved);
        await bondContract.transferFrom(lender, secondaryMarketBuyer2, firstBondId, firstNonceId, 3000, {from: operator})
        assert.equal((await bondContract.balanceOf(lender, firstBondId, firstNonceId)).toNumber(), 9000);
        assert.equal((await bondContract.balanceOf(secondaryMarketBuyer2, firstBondId, firstNonceId)).toNumber(), 3000);

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
