const C2CMarketCoin = artifacts.require("C2CMarketCoin");

module.exports = function(deployer) {
  deployer.deploy(C2CMarketCoin);
};
