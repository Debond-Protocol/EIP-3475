import {BondInstance} from "../types/truffle-contracts";


const Bond = artifacts.require("Bond");

contract('Bond', async (accounts: string[]) => {

    let bondContract: BondInstance;
    const lender = accounts[1];
    const operator = accounts[2];
    const secondaryMarketBuyer = accounts[3];
    const secondaryMarketBuyer2 = accounts[4];


    it('should create new bonds ', async () => {
        bondContract = await Bond.deployed();
        await bondContract.createBond(0, 0, "DBIT-USDT", Date.now(), Date.now() + 30 * 24 * 3600);
        await bondContract.createBond(0, 1, "DBIT-USDT", Date.now(), Date.now() + 60 * 24 * 3600);
        await bondContract.createBond(0, 2, "DBIT-USDT", Date.now(), Date.now() + 90 * 24 * 3600);

        await bondContract.createBond(1, 0, "DBIT-USDC", Date.now(), Date.now() + 30 * 24 * 3600);
        await bondContract.createBond(2, 0, "DBIT-DAI", Date.now(), Date.now() + 30 * 24 * 3600);
        await bondContract.createBond(3, 0, "DBIT-ETH", Date.now(), Date.now() + 30 * 24 * 3600);
        const bonds = (await bondContract.getClasses()).map(b => b.toNumber())
        console.log(bonds)
        // const infos = await bondContract.infos(0, 0);
        // console.log(infos);
        assert.isArray(bonds);
    })

    it('should issue bonds to a lender ', async () => {
        await bondContract.issue(lender, 0, 0, 7000, {from: accounts[0]})
        const balance = (await bondContract.balanceOf(lender, 0, 0)).toNumber()
        const activeSupply = (await bondContract.activeSupply(0, 0)).toNumber()
        assert.equal(balance, 7000);
        assert.equal(activeSupply, 7000);
    })
    //
    it('should be able the lender to transfer bonds to another address', async () => {
        await bondContract.transferFrom(lender, secondaryMarketBuyer, 0, 0, 2000, {from: lender})
        const lenderBalance = (await bondContract.balanceOf(lender, 0, 0)).toNumber()
        const secondaryBuyerBalance = (await bondContract.balanceOf(secondaryMarketBuyer, 0, 0)).toNumber()
        const activeSupply = (await bondContract.activeSupply(0, 0)).toNumber()
        assert.equal(lenderBalance, 5000);
        assert.equal(secondaryBuyerBalance, 2000);
        assert.equal(activeSupply, 7000);
    })
    //
    it('should be able to manipulate bonds after approval', async () => {
        await bondContract.setApprovalFor(operator, [0, 0, 0], [0, 1, 2], true, {from: lender})
        const isApproved = await bondContract.isApprovedFor(lender, operator, 0, 0);
        assert.isTrue(isApproved);
        await bondContract.transferFrom(lender, secondaryMarketBuyer2, 0, 0, 3000, {from: operator})
        assert.equal((await bondContract.balanceOf(lender, 0, 0)).toNumber(), 2000);
        assert.equal((await bondContract.balanceOf(secondaryMarketBuyer2, 0, 0)).toNumber(), 3000);

    })
    //
    it('should burn supply of the bond', async () => {
        await bondContract.redeem(lender, 0, 0, 2000);
        await bondContract.redeemedSupply(0, 0);
    })
    //
    // it('should redeem bonds when conditions are met', async () => {
    //
    // })


});
