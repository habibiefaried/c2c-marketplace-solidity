const C2CMarketCoin = artifacts.require("C2CMarketCoin");

contract('C2CMarketCoin', (accounts) => {
  it('It should initialize', async () => {
    const c2CMarketCoinInstance = await C2CMarketCoin.deployed();
    const address = await c2CMarketCoinInstance.getOwnerAddress.call();
    assert.equal(address, accounts[0], "It is deployed using first account");
  });

  it('Test pay deposit ok', async () => {
    const c2CMarketCoinInstance = await C2CMarketCoin.deployed();

    // Deposit from first acc
    await c2CMarketCoinInstance.deposit({from: accounts[1], value: web3.utils.toWei("0.025", "ether")});
    let balance = await c2CMarketCoinInstance.getBalances.call(accounts[1]);
    assert.equal(balance[0], 25, "Deposit working properly"); // should have 25 coins

    // Deposit from second acc
    await c2CMarketCoinInstance.deposit({from: accounts[2], value: web3.utils.toWei("0.0025", "ether")});
    balance = await c2CMarketCoinInstance.getBalances.call(accounts[2]);
    assert.equal(balance[0], 2, "Deposit working properly"); // should have 2 coins and 0.5 fraction coin
    assert.equal(web3.utils.fromWei(balance[1], "ether"), 0.5, "We cannot return fractions on function, but recorded properly");

    // Deposit from third acc
    await c2CMarketCoinInstance.deposit({from: accounts[3], value: web3.utils.toWei("0.00025", "ether")});
    balance = await c2CMarketCoinInstance.getBalances.call(accounts[3]);
    assert.equal(balance[0], 0, "Deposit working properly"); // should have 0 coins and 0.25 fraction coin
    assert.equal(web3.utils.fromWei(balance[1], "ether"), 0.25, "We cannot return fractions on function, but recorded properly");

    // see the total balance of contract has
    mybalance = await c2CMarketCoinInstance.getContractBalanceETH.call();
    assert.equal(mybalance, web3.utils.toWei("0.02775", "ether"), "Contract balance in ether is also correct");
  });
});
