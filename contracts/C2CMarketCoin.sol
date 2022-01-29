// SPDX-License-Identifier: MIT
// For demonstration, 1 eth is equal to 1000 C2CMarketCoin

pragma solidity ^0.8.0;

import "../contracts/C2CMarketCoinERC20.sol";

contract C2CMarketCoin is C2CMarketCoinERC20 {
	address payable _contactOwner;

	event Deposit(address indexed sender, uint amount, uint balance);

	constructor() {
		_contactOwner = payable(tx.origin);
    }

	function getOwnerAddress() public view returns (address) {
		return _contactOwner;
	}

	function mint() external payable {
		uint256 money = msg.value * 1000;

		_balances[msg.sender] += money;
		_totalSupply += money;
		emit Deposit(msg.sender, msg.value, address(this).balance);
	}

	function getContractBalanceETH() external view returns (uint256) {
        return address(this).balance;
    }
}
