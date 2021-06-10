const CarInsurance = artifacts.require("CarInsurance");

module.exports = function(deployer) {
  deployer.deploy(CarInsurance, {value: "5000"}); //Initialise with 5000 balance
};
