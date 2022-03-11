import {ERC3475Instance} from "../types/truffle-contracts";


const Bond = artifacts.require("ERC3475");

contract('Bond', async (accounts: string[]) => {

    let bondContract: ERC3475Instance;
    const lender = accounts[1];
    const operator = accounts[2];
    const secondaryMarketBuyer = accounts[3];
    const secondaryMarketBuyer2 = accounts[4];
    const spender = accounts[5];

    const DBITClassId = 0

    const firstNonceId = 0;

    it('should issue bonds to a lender ', async () => {
        bondContract = await Bond.deployed();
        await bondContract.issue(lender, DBITClassId, firstNonceId, 7000, {from: accounts[0]})
        await bondContract.issue(lender, DBITClassId, firstNonceId, 7000, {from: accounts[0]})
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
        await bondContract.setApprovalFor(operator, DBITClassId, true, {from: lender})
        const isApproved = await bondContract.isApprovedFor(lender, operator, DBITClassId);
        assert.isTrue(isApproved);
        await bondContract.transferFrom(lender, secondaryMarketBuyer2, DBITClassId, firstNonceId, 3000, {from: operator})
        assert.equal((await bondContract.balanceOf(lender, DBITClassId, firstNonceId)).toNumber(), 9000);
        assert.equal((await bondContract.balanceOf(secondaryMarketBuyer2, DBITClassId, firstNonceId)).toNumber(), 3000);

    })
    //
    //
    it('should redeem bonds when conditions are met', async () => {
        await bondContract.redeem(lender, DBITClassId, firstNonceId, 3000);
        assert.equal((await bondContract.balanceOf(lender, DBITClassId, firstNonceId)).toNumber(), 6000);
    })


    //////////////////// UNIT TESTS //////////////////////////////


    it('should transfer bonds from an caller address to another', async () => {
        const tx = (await bondContract.transferFrom(lender, secondaryMarketBuyer, DBITClassId, firstNonceId, 500, {from: lender})).tx;
        console.log(tx)
        assert.isString(tx);
    })

    it('should issue bonds to a given address', async () => {
        const tx = (await bondContract.issue(lender, DBITClassId, firstNonceId, 500)).tx;
        console.log(tx)
        assert.isString(tx);
    })

    it('should redeem bonds from a given address', async () => {
        const tx = (await bondContract.redeem(lender, DBITClassId, firstNonceId, 500)).tx;
        console.log(tx)
        assert.isString(tx);
    })

    it('should burn bonds from a given address', async () => {
        const tx = (await bondContract.burn(lender, DBITClassId, firstNonceId, 500)).tx;
        console.log(tx)
        assert.isString(tx);
    })

    it('should approve spender to manage a given amount of bonds from the caller address', async () => {
        const tx = (await bondContract.approve(spender, DBITClassId, firstNonceId, 500, {from: lender})).tx;
        console.log(tx)
        assert.isString(tx);
    })

    it('should setApprovalFor operator to manage bonds from classId given from the caller address', async () => {
        const tx = (await bondContract.setApprovalFor(operator, DBITClassId, true, {from: lender})).tx;
        console.log(tx)
        assert.isString(tx);
    })

    it('should batch approve', async () => {
        const tx = (await bondContract.batchApprove(spender, [DBITClassId], [firstNonceId], [500], {from: lender})).tx;
        console.log(tx)
        assert.isString(tx);
    })





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

    it('should return the infos of a bond class given', async () => {
        const infos = (await bondContract.classInfos(DBITClassId));
        console.log("class infos: ", JSON.stringify(infos))
        infos.forEach(async i => {
            console.log(await bondContract.classInfoMapping(i))
        });
    })

    it('should return the infos of a nonce of bond class given', async () => {
        const infos = (await bondContract.nonceInfos(DBITClassId, firstNonceId));
        console.log("nonce infos: ", JSON.stringify(infos))
        infos.forEach(async i => {
            console.log(await bondContract.nonceInfoMapping(i))
        });
    })

    it('should return if an operator is approved on a class and nonce given for an address', async () => {
        const isApproved = (await bondContract.isApprovedFor(lender, operator, DBITClassId));
        console.log("operator is Approved? : ", isApproved)
        assert.isBoolean(isApproved);
    })

    it('should return if is redeemable', async () => {
        const isRedeemable = await bondContract.isRedeemable(DBITClassId, firstNonceId);
        console.log("is Redeemable? : ", isRedeemable)
        assert.isBoolean(isRedeemable);
    })

    it('should return allowance of a spender', async () => {
        const allowance = (await bondContract.allowance(lender, spender, DBITClassId, firstNonceId)).toNumber();
        console.log("allowance : ", allowance)
        assert.isNumber(allowance);
    })

    it('should return if operator is approved for', async () => {
        const isApproved = (await bondContract.isApprovedFor(lender, operator, DBITClassId));
        console.log("operator is Approved? : ", isApproved)
        assert.isBoolean(isApproved);
    })

});
