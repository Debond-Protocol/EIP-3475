const TestTokena = artifacts.require("TestTokena");

module.exports = function (deployer) {
  deployer.deploy(TestTokena,"teaast","tss",18);
};
