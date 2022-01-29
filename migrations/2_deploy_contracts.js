const C2CMarketCoinERC20 = artifacts.require("C2CMarketCoinERC20");
const C2CMarketCoin = artifacts.require("C2CMarketCoin");

module.exports = function(deployer) {
  deployer.deploy(C2CMarketCoinERC20);
  deployer.deploy(C2CMarketCoin);
};
