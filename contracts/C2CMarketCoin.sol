// SPDX-License-Identifier: MIT
// For demonstration, 1 eth is equal to 1000 C2CMarketCoin
// 1 user is ONLY able to handle 1 store

pragma solidity ^0.8.0;

import "../contracts/C2CMarketCoinERC20.sol";
import "../contracts/C2CMarketCoinStore.sol";

contract C2CMarketCoin is C2CMarketCoinERC20 {
	address payable _contractOwner;
	mapping(address => C2CMarketCoinStore) private _allstores;
	mapping(address => bool) private _allinitializedstore;

	event Deposit(address indexed sender, uint256 amount, uint256 currentBalance);
	event Withdraw(address indexed to, uint256 amount, uint256 currentBalance);
	event SetItem(address indexed from, string name, uint256 price, uint256 qty, string imagelink);

	modifier onlyOwner() {
        require(msg.sender == _contractOwner, "not owner");
        _;
    }

    modifier onlyMintedStoreOwner() {
        require(_allinitializedstore[msg.sender], "you need to mint money first");
        _;
    }

	constructor() {
		_contractOwner = payable(msg.sender);
    }

	function getOwnerAddress() public view returns (address) {
		return _contractOwner;
	}

	function isStoreInitialized() external view returns (bool){
		return _allinitializedstore[msg.sender];
	}

	function mint() external payable {
		require(msg.value > 0, "invalid amount of money");
		uint256 money = msg.value * 1000;
		_balances[msg.sender] += money;
		_totalSupply += money;

		if (_allinitializedstore[msg.sender] == false){
			_allinitializedstore[msg.sender] = true;
			_allstores[msg.sender] = new C2CMarketCoinStore(msg.sender);
		}
		emit Deposit(msg.sender, msg.value, address(this).balance);
	}

	function setMyItem(
		string memory _itemname, 
		uint256 _itemprice,
		uint256 _qty,
		string memory _imagelink
		)
	external onlyMintedStoreOwner {
		_allstores[msg.sender].setItem(_itemname, _itemprice, _qty, _imagelink);
		emit SetItem(msg.sender, _itemname, _itemprice, _qty, _imagelink);
	}

	function getMyItem(string memory _itemname) external view onlyMintedStoreOwner returns (uint256, uint256, string memory) {
		return _allstores[msg.sender].getOneItem(_itemname);
	}

	// Related to ETH
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
