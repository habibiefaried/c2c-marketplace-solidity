const C2CMarketCoin = artifacts.require("C2CMarketCoin");

contract('C2CMarketCoin', (accounts) => {
  const itemName = "jacket";
  const jacketQty = 5;
  //const jacketPrice = 1000000000000000000; // 1 C2CMarketCoin
  const jacketPrice = web3.utils.toWei("0.001", "ether") * 1000; // 1 C2CMarketCoin


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
    await c2CMarketCoinInstance.mint({from: accounts[2], value: web3.utils.toWei("0.0025", "ether")}); // should have 2.5 coins
    balance = await c2CMarketCoinInstance.balanceOf.call(accounts[2]);
    assert.equal(balance, web3.utils.toWei("0.0025", "ether") * 1000, "Deposit working properly"); 

    // Deposit from third acc
    await c2CMarketCoinInstance.mint({from: accounts[3], value: web3.utils.toWei("0.00025", "ether")}); // should have 0.25 coins
    balance = await c2CMarketCoinInstance.balanceOf.call(accounts[3]);
    assert.equal(balance, web3.utils.toWei("0.00025", "ether") * 1000, "Deposit working properly"); 

    // see the total balance of contract has
    mybalance = await c2CMarketCoinInstance.getContractBalanceETH.call();
    assert.equal(mybalance, web3.utils.toWei("0.02775", "ether"), "Contract balance in ether is also correct");

    // total supply
    totalsupply = await c2CMarketCoinInstance.totalSupply.call();
    assert.equal(totalsupply, web3.utils.toWei("0.02775", "ether") * 1000, "Total supply expected");


  });

  it('Rescuing ETH', async () => {
    const c2CMarketCoinInstance = await C2CMarketCoin.deployed();

    let contractbalance = await c2CMarketCoinInstance.getContractBalanceETH.call();
    assert.equal(contractbalance, web3.utils.toWei("0.02775", "ether"), "Initial from test above");
    let ownerbalance = await web3.eth.getBalance(accounts[0]);
    afterreturn = await contractbalance.add(web3.utils.toBN(ownerbalance));

    try {
      // make sure only the owner is able to rescue
      let c = await c2CMarketCoinInstance.rescueETH.call({from: accounts[1]});
      assert.fail("The transaction should have thrown an error");
    } catch (err) {
      assert.include(err.message, "revert", "The error message should contain 'revert'");
    }

    let moneySent = await c2CMarketCoinInstance.rescueETH.call();
    assert.equal(moneySent.toString(), contractbalance.toString(), "sending expected money to sender");
  });

  it('After rescuing ETH', async() => {
    const c2CMarketCoinInstance = await C2CMarketCoin.deployed();

    let contractbalanceafter = await c2CMarketCoinInstance.getContractBalanceETH.call();
    assert.equal(contractbalanceafter, web3.utils.toWei("0.02775", "ether"), "The money is still there after calling rescue, ok..");
  });

  it('Add items', async() => {
    const c2CMarketCoinInstance = await C2CMarketCoin.deployed();
    await c2CMarketCoinInstance.setMyStoreItem(itemName, jacketPrice.toString(), jacketQty, "https://store.com/jacket.png", {from: accounts[1]});
    let zeitem = await c2CMarketCoinInstance.getMyStoreItem(itemName, {from: accounts[1]});

    assert.equal(zeitem[0], jacketPrice, "Item price is correct");
    assert.equal(zeitem[1], jacketQty, "Qty of item is correct");
    assert.equal(zeitem[2], "https://store.com/jacket.png", "Link is correct");

    try {
      // make sure only account that minted will be able to store item
      await c2CMarketCoinInstance.setMyStoreItem("shoes", 1, 2, "https://store.com/shoes.png", {from: accounts[5]});
      assert.fail("Your account didn't mint any coin yet");
    } catch (err) {
      assert.include(err.message, "revert", "The error message should contain 'revert'");
    }
  });

  it('Buy item from account 2', async() => {
    const c2CMarketCoinInstance = await C2CMarketCoin.deployed();
    const buyJacketQtyAcc2 = 2;

    let balanceAcc1Before = await c2CMarketCoinInstance.balanceOf(accounts[1]);
    let balanceAcc2Before = await c2CMarketCoinInstance.balanceOf(accounts[2]);
    await c2CMarketCoinInstance.buyItem(accounts[1], itemName, buyJacketQtyAcc2, {from: accounts[2]}); // buy jacket on store account[1] from account[2]
    let balanceAcc1After = await c2CMarketCoinInstance.balanceOf(accounts[1]);
    let balanceAcc2After = await c2CMarketCoinInstance.balanceOf(accounts[2]);

    let zeowner = await c2CMarketCoinInstance.getMyOwnedItem(0, {from: accounts[2]}); // on account[2]
    assert.equal(zeowner[0], accounts[1], "Equal to origin store");
    assert.equal(zeowner[1], itemName, "The item is "+itemName);
    assert.equal(zeowner[2], buyJacketQtyAcc2, "Bought "+buyJacketQtyAcc2+" jackets");

    let zeitem = await c2CMarketCoinInstance.getMyStoreItem("jacket", {from: accounts[1]});
    assert.equal(zeitem[1], jacketQty - buyJacketQtyAcc2, "Check current qty of "+itemName+" in acc1");

    assert.equal(balanceAcc2Before - (buyJacketQtyAcc2 * jacketPrice), balanceAcc2After, "Equal on acc2 after transaction");
    assert.equal(balanceAcc1After - (buyJacketQtyAcc2 * jacketPrice), balanceAcc1Before, "Equal on acc1 after transaction");
  });

  it('Buy item from account 3', async() => {
    const c2CMarketCoinInstance = await C2CMarketCoin.deployed();
    const buyJacketQtyAcc3 = 3;
    let balanceAcc3Before = await c2CMarketCoinInstance.balanceOf.call(accounts[3]);

    try {
      // buy jacket on store account[1] from account[3]
      await c2CMarketCoinInstance.buyItem(accounts[1], itemName, buyJacketQtyAcc3, {from: accounts[3]});     
      assert.fail("Should error because lack of money");
    } catch (err) {
      assert.include(err.message, "revert", "The error message should contain 'revert'");
    }
    
  });
});
