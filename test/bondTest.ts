import { before } from "mocha";
import {ERC3475Instance} from "../types/truffle-contracts";


const Bond = artifacts.require("ERC3475");

contract('Bond', async (accounts: string[]) => {

    let bondContract: ERC3475Instance;
    const lender = accounts[1];
    const operator = accounts[2];
    const secondaryMarketBuyer = accounts[3];
    const secondaryMarketBuyer2 = accounts[4];
    const spender = accounts[5];

    interface _transaction  {
        classId: string | number | BN;
        nonceId: string | number | BN;
        _amount: string | number | BN;
    }



    const DBITClassId: number  = 0;
    const firstNonceId:  number = 0;
  
    it('should issue bonds to a lender ', async () => {
        bondContract = await Bond.deployed();
        let _transactionIssuer : _transaction[] 
        = 
        [{
            classId:DBITClassId,
            nonceId:firstNonceId,
            _amount: 7000 }];

        //const transaction {}

        await bondContract.issue(lender, _transactionIssuer, {from: accounts[0]})
        await bondContract.issue(lender, _transactionIssuer, {from: accounts[0]})
        const balance = (await bondContract.balanceOf(lender, DBITClassId, firstNonceId)).toNumber()
        const activeSupply = (await bondContract.activeSupply(DBITClassId, firstNonceId)).toNumber()
        assert.equal(balance, 14000);
        assert.equal(activeSupply, 14000);
    })
    //
    it('should be able the lender to transfer bonds to another address', async () => {

        const transferBonds : _transaction[] = [
            {classId:DBITClassId,
            nonceId:firstNonceId,
            _amount: 2000

            }];

        await bondContract.transferFrom(lender, secondaryMarketBuyer, transferBonds, {from: lender})
        const lenderBalance = (await bondContract.balanceOf(lender, DBITClassId, firstNonceId)).toNumber()
        const secondaryBuyerBalance = (await bondContract.balanceOf(secondaryMarketBuyer, DBITClassId, firstNonceId)).toNumber()
        const activeSupply = (await bondContract.activeSupply(DBITClassId, firstNonceId)).toNumber()
        assert.equal(lenderBalance, 12000);
        assert.equal(secondaryBuyerBalance, 2000);
        assert.equal(activeSupply, 14000);
    })
    //
    it('should be able to manipulate bonds after approval', async () => {
        const transactionApproval : _transaction[] = [
            {classId:DBITClassId,
            nonceId:firstNonceId,
            _amount: 2000

            }];
        await bondContract.setApprovalFor(operator, DBITClassId, true, {from: lender})
        const isApproved = await bondContract.isApprovedFor(lender, operator, DBITClassId);
        assert.isTrue(isApproved);
        await bondContract.transferFrom(lender, secondaryMarketBuyer2, transactionApproval, {from: operator})
        assert.equal((await bondContract.balanceOf(lender, DBITClassId, firstNonceId)).toNumber(), 9000);
        assert.equal((await bondContract.balanceOf(secondaryMarketBuyer2, DBITClassId, firstNonceId)).toNumber(), 3000);

    })
    //
    //
    it('should redeem bonds when conditions are met', async () => {
        const redemptionTransaction : _transaction[] = [
            {classId:DBITClassId,
            nonceId:firstNonceId,
            _amount: 2000

            }];

        await bondContract.redeem(lender, redemptionTransaction);
        assert.equal((await bondContract.balanceOf(lender, DBITClassId, firstNonceId)).toNumber(), 6000);
    })


    //////////////////// UNIT TESTS //////////////////////////////


    it('should transfer bonds from an caller address to another', async () => {

        const transactionTransfer : _transaction[] = [
            {classId:DBITClassId,
            nonceId:firstNonceId,
            _amount: 500

            }];
        const tx = (await bondContract.transferFrom(lender, secondaryMarketBuyer, transactionTransfer)).tx;
        console.log(tx)
        assert.isString(tx);
    })

    it('should issue bonds to a given address', async () => {
      
        const transactionIssue : _transaction[] = [
            {classId:DBITClassId,
            nonceId:firstNonceId,
            _amount: 500

            }];

      
        const tx = (await bondContract.issue(lender, transactionIssue)).tx;
        console.log(tx)
        assert.isString(tx);
    })

    it('should redeem bonds from a given address', async () => {
        const transactionRedeem : _transaction[] = [
            {classId:DBITClassId,
            nonceId:firstNonceId,
            _amount: 500

            }];

        const tx = (await bondContract.redeem(lender, transactionRedeem)).tx;
        console.log(tx)
        assert.isString(tx);
    })

    it('should burn bonds from a given address', async () => {
        const transactionRedeem : _transaction[] = [
            {classId:DBITClassId,
            nonceId:firstNonceId,
            _amount: 500
            }];
        const tx = (await bondContract.burn(lender, transactionRedeem)).tx;
        console.log(tx)
        assert.isString(tx);
    })

    it('should approve spender to manage a given amount of bonds from the caller address', async () => {
        const transactionApprove : _transaction[] = [
            {classId:DBITClassId,
            nonceId:firstNonceId,
            _amount: 500
            }];
        const tx = (await bondContract.approve(spender, transactionApprove)).tx;
        console.log(tx)
        assert.isString(tx);
    })

    it('should setApprovalFor operator to manage bonds from classId given from the caller address', async () => {
        const tx = (await bondContract.setApprovalFor(operator, DBITClassId, true, {from: lender})).tx;
        console.log(tx)
        assert.isString(tx);
    })

    it('should batch approve', async () => {
       
        const transactionApprove : _transaction[] = [
            {classId:DBITClassId,
            nonceId:firstNonceId,
            _amount: 500
            },
            {classId:1, nonceId: 1, _amount:900 }
        
        ];
       
       
        const tx = (await bondContract.approve(spender,transactionApprove)).tx;
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
        
        const symbol: BN[] = (await bondContract.classValues(DBITClassId));
        console.log(JSON.stringify(symbol[0]));
        assert.isString(symbol.toString);
    })

    it('should return the infos of a bond class given', async () => {
        const infos = (await bondContract.classValues(DBITClassId));
        console.log("class infos: ", JSON.stringify(infos))
        infos.forEach( i => {
            console.log(i.toNumber())
        });
    })

    it('should return the infos of a nonce of bond class given', async () => {
        const infos = (await bondContract.nonceValues(DBITClassId, firstNonceId));
        console.log("nonce infos: ", JSON.stringify(infos))
        infos.forEach(i => {
            console.log(i.toNumber())
        });
    })

    it('should return if an operator is approved on a class and nonce given for an address', async () => {
        const isApproved = (await bondContract.isApprovedFor(lender, operator, DBITClassId));
        console.log("operator is Approved? : ", isApproved)
        assert.isBoolean(isApproved);
    })

    it('should return if is redeemable', async () => {
        const getProgress = await bondContract.getProgress(DBITClassId, firstNonceId);
        console.log("is Redeemable? : ", getProgress[1].toNumber() == 0)
        assert.isNumber(getProgress[0].toNumber());
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
