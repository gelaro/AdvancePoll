var Election = artifacts.require("./Election.sol");
var Poll = artifacts.require("./Poll.sol");

module.exports = function(deployer) {
  deployer.deploy(Election);
  deployer.deploy(Poll);
};
