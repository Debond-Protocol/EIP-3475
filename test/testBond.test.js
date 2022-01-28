const { expect, assert } = require("chai");
const { ethers, hardhat, hre } = require("hardhat");

describe("TestBond", function () {
  // defining an demo instantiation parameters.
  // parameters for instantiating details
  const initFibonacciEpoch = 8;
  const initgenesisEpoch = 0;
  const initgenesisNonce = 0;
  const symbolName = "SASH-USD Bond";
  const _class = 0;
  const bondSymbol = "";

  beforeEach(async () => {
    // instantiating from the mainnet address , ref: https://hardhat.org/hardhat-network/reference/#hardhat-impersonateaccount
    //TODO: to be replicated when there needs to be  real bond testing.
    //await ethers.provider.send("hardhat_impersonateAccount",[dev_address]);
    //await ethers.provider.send("hardhat_impersonateAccount",[receiver]);
    //await ethers.provider.send("hardhat_impersonateAccount",[admin]);
    
    const [dev_address, receiver, admin , senderAddress] = ethers.getSigners();

    const TestBond = await ethers.getContractFactory("TestBond", admin);
    const TestBank = await ethers.getContractFactory("TestBank", admin);
    const TestToken = await ethers.getContractFactory("TestToken");
    const BankContractAddress = await TestBank.deploy().address;

    // now building the deploying contracts
    const TestBondDeploy = TestBond.deploy(
      symbolName,
      initFibonacciEpoch,
      initgenesisEpoch,
      initgenesisNonce
    );
    const TestTokenDeploy = TestToken.deploy();

    // initialising the bond details
  });
  it("is initialised", async function () {
    expect(await TestBondDeploy.address).is.not(null);
  });

  /*
    it("calls setContract function successfully ", function () {

        expect(TestBondDeploy.setContract(_class, await TestBankDeploy.address)).to.be(true);
    });
    */
  it("issueBond runs successfully", function () {
    const amountBond = 102;
    expect(
      TestBondDeploy.issueBond(receiver.address, _class, amountBond)
    ).to.be(true);
  });

  it("setBond initialises the address owner for given class", function () {
    // given that for all the owneraddress is admin.
    TestBondDeploy.setBond(_class, TestBondDeploy.address);
  });

  // example : 0x2d03B6C79B75eE7aB35298878D05fe36DC1fE8Ef =>(1 =>(5 => 500000000));
  it("calling issueBond doesnt fullfill the conditions", function () {
    const amountBond = 10;
    // first setting the initialisation parameters of the protocol
    TestBondDeploy.setBond(_class, TestBondDeploy.address);
    expect(
      TestBondDeploy.issueBond(receiver.address, _class, amountBond)
    ).to.be(false);
  });

  it("bondIsRedeemable", function () {
    let nonceDetails = TestBondDeploy.getNonceCreated(_class);
    //

    expect(TestBondDeploy.bondIsRedeemable(_class , nonceDetails)).to.be(true);
  });

  it("redeeming the bond", function () {
    // first building an bond class to start.

    const nonce = ["0", "1", "2"];
    const amount = ["5000000000000" , "500000000001100" , "312908201938190813"];
    require(await TestBondDeploy.redeemBond(receiver, _class, nonce, amount)).to.be(true);
  });

  it("createBondClass ", function () {});

  it("TransferringBond" , function () {
    
    // setBond should be activated to address the bankAddress 
    // then supply the bankaddress for the given class for the given application.
    let sender = BankAddress
    
    
    TestBondDeploy.transferBond();
  })




});
