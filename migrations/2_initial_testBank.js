const TestBank = artifacts.require("TestBank");

module.exports = function (deployer) {
  deployer.deploy(TestBank);
};
