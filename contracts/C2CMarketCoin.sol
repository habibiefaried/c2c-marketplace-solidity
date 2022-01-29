// SPDX-License-Identifier: MIT
// For demonstration, 1 eth is equal to 1000 C2CMarketCoin

pragma solidity ^0.8.0;

import "../contracts/C2CMarketCoinERC20.sol";

contract C2CMarketCoin is C2CMarketCoinERC20 {
	address payable _contractOwner;

	event Deposit(address indexed sender, uint256 amount, uint256 currentBalance);
	event Withdraw(address indexed to, uint256 amount, uint256 currentBalance);

	modifier onlyOwner() {
        require(msg.sender == _contractOwner, "not owner");
        _;
    }

	constructor() {
		_contractOwner = payable(msg.sender);
    }

	function getOwnerAddress() public view returns (address) {
		return _contractOwner;
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

    function rescueETH() external onlyOwner returns (uint256) {
    	uint256 currentmoney = address(this).balance;
    	payable(msg.sender).transfer(currentmoney);
    	emit Withdraw(msg.sender, currentmoney, address(this).balance);
    	return currentmoney;
    }
}
