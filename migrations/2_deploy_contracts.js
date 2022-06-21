const ERC3475 = artifacts.require("ERC3475");

module.exports = async function (deployer,network, accounts) {
    deployer.deploy(ERC3475);
};