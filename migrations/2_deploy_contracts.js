var SafeMath = artifacts.require("./SafeMath.sol");
var XY = artifacts.require("./XY.sol");

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, XY);
  deployer.deploy(XY);
};
