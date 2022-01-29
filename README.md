# Description
c2c e-marketplace in solidity

# Install

Need to install openzeppelin first

```
npm install openzeppelin-solidity
```

# Commands

```
  Compile contracts: truffle compile --all --quiet
  Migrate contracts: truffle migrate --reset --quiet
  Test contracts:    truffle test --quiet
```

Some on console

```
let accounts = await web3.eth.getAccounts()
let c2CMarketCoinInstance = await C2CMarketCoin.deployed();
```