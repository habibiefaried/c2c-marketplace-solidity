# Description
[![Coverage Status](https://coveralls.io/repos/github/habibiefaried/c2c-marketplace/badge.svg)](https://coveralls.io/github/habibiefaried/c2c-marketplace)
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

# Reference
* Truffle & Solc: https://trufflesuite.com/docs/truffle/quickstart.html (unbox MetaCoin project for skeleton)
* Solidity: https://solidity-by-example.org/
* JS Web3 library: https://web3js.readthedocs.io/en/v1.2.11/web3.html
* Contracts: https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts
* Coverage: https://coveralls.io/
* Static code check: https://app.codechecks.io/