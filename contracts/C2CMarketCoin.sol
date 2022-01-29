// SPDX-License-Identifier: MIT
// For demonstration, 1 eth deposit is equal to 1000 C2CMarketCoin

pragma solidity >=0.4.25 <0.7.0;

contract C2CMarketCoin {
	mapping (address => uint) balances;
	address payable owner;

	event Deposit(address indexed sender, uint amount, uint balance);

	constructor() public {
		owner = tx.origin;
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
