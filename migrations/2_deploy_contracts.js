const Bond = artifacts.require("Bond");

module.exports = function (deployer) {
  deployer.deploy(Bond);
};
