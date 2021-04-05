const TestBond = artifacts.require("TestBond");

module.exports = function (deployer) {
  deployer.deploy(TestBond);
};
