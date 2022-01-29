// SPDX-License-Identifier: MIT
// For demonstration, 1 eth deposit is equal to 1000 C2CMarketCoin

pragma solidity ^0.8.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract C2CMarketCoin is ERC20 {
	mapping (address => uint) balances;
	address payable owner;

	event Deposit(address indexed sender, uint amount, uint balance);

	constructor() ERC20("C2CMarketCoin", "C2CM") {
		owner = payable(tx.origin);
    }

	function getOwnerAddress() public view returns (address) {
		return owner;
	}

	function deposit() external payable {
		balances[msg.sender] += msg.value;
		emit Deposit(msg.sender, msg.value, address(this).balance);
	}

	function getBalances(address addr) public view returns (uint, uint){
		return (balances[addr] * 1000 / 1 ether, balances[addr] * 1000 % 1 ether);
	}

	function getContractBalanceETH() external view returns (uint) {
        return address(this).balance;
    }
}
