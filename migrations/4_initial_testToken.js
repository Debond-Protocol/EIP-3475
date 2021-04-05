const TestToken = artifacts.require("TestToken");

module.exports = function (deployer) {
  deployer.deploy(TestToken,"test","ts",18);
};
