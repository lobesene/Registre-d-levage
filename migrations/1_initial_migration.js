const Migrations = artifacts.require("Migrations");
const Animals = artifacts.require("Animals");
const Fight= artifacts.require("Fight");
module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(Animals);
  deployer.deploy(Fight);
};
