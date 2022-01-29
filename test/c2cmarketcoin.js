const C2CMarketCoin = artifacts.require("C2CMarketCoin");

contract('C2CMarketCoin', (accounts) => {
  it('Test init', async () => {
    const c2CMarketCoinInstance = await C2CMarketCoin.deployed();
    const address = await c2CMarketCoinInstance.getOwnerAddress.call();
    assert.equal(address, accounts[0], "It is deployed using first account");
  });

  it('Test pay deposit', async () => {
    const c2CMarketCoinInstance = await C2CMarketCoin.deployed();

    // Deposit from first acc
    await c2CMarketCoinInstance.mint({from: accounts[1], value: web3.utils.toWei("0.025", "ether")});
    let balance = await c2CMarketCoinInstance.balanceOf.call(accounts[1]);
    assert.equal(balance, web3.utils.toWei("0.025", "ether") * 1000, "Deposit working properly"); // should have 25 coins

    // Deposit from second acc
    await c2CMarketCoinInstance.mint({from: accounts[2], value: web3.utils.toWei("0.0025", "ether")});
    balance = await c2CMarketCoinInstance.balanceOf.call(accounts[2]);
    assert.equal(balance, web3.utils.toWei("0.0025", "ether") * 1000, "Deposit working properly"); 

    // Deposit from third acc
    await c2CMarketCoinInstance.mint({from: accounts[3], value: web3.utils.toWei("0.00025", "ether")});
    balance = await c2CMarketCoinInstance.balanceOf.call(accounts[3]);
    assert.equal(balance, web3.utils.toWei("0.00025", "ether") * 1000, "Deposit working properly"); 

    // see the total balance of contract has
    mybalance = await c2CMarketCoinInstance.getContractBalanceETH.call();
    assert.equal(mybalance, web3.utils.toWei("0.02775", "ether"), "Contract balance in ether is also correct");

    // total supply
    totalsupply = await c2CMarketCoinInstance.totalSupply.call();
    assert.equal(totalsupply, web3.utils.toWei("0.02775", "ether") * 1000, "Total supply expected");
  });
});
