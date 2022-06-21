const ERC3475 = artifacts.require("ERC3475");

module.exports = async function (deployer) {
    deployer.deploy(ERC3475);
    const bond = ERC3475.deployed();
    await bond.init();

};