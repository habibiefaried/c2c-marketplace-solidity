// SPDX-License-Identifier: MIT
// For demonstration
// 1 eth = 1000000000000000000 wei
// 1 C2CMarketCoin = 1000000000000000000 * 1000 wei (upscale)
// All of data here is stored in wei
// 1 user is ONLY able to handle 1 store 

pragma solidity ^0.8.0;

import "../contracts/C2CMarketCoinERC20.sol";
import "../contracts/C2CMarketCoinStore.sol";

contract C2CMarketCoin is C2CMarketCoinERC20 {
	struct ItemOwnership { 
		address store; // from which store the user bought this
		string name; // name of the item
		uint256 qty; // quantity you bought at that time
		string imagelink; // link to the image
   	}

	address payable _contractOwner;
	mapping(address => C2CMarketCoinStore) private _allstores;
	mapping(address => bool) private _allinitializedstore;
	mapping(address => ItemOwnership[]) private _ownerships; // key value between the user and his/her item ownership

	event Deposit(address indexed sender, uint256 amount, uint256 currentBalance);
	event Withdraw(address indexed to, uint256 amount, uint256 currentBalance);
	event SetItem(address indexed from, string name, uint256 price, uint256 qty, string imagelink);

	modifier onlyOwner() {
        require(msg.sender == _contractOwner, "not owner");
        _;
    }

    modifier onlyMintedStoreOwner(address callee) {
        require(_allinitializedstore[callee], "This acc needs to mint token first");
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

	function setMyStoreItem(
		string memory _itemname, 
		uint256 _itemprice,
		uint256 _qty,
		string memory _imagelink
	)
	external onlyMintedStoreOwner(msg.sender)
	{
		_allstores[msg.sender].setItem(_itemname, _itemprice, _qty, _imagelink);
		emit SetItem(msg.sender, _itemname, _itemprice, _qty, _imagelink);
	}

	function getMyStoreItem(string memory _itemname)
		external view onlyMintedStoreOwner(msg.sender)
	returns (
		uint256,
		uint256,
		string memory
	) {
		return _allstores[msg.sender].getOneItem(_itemname);
	}

	function buyItem(
		address storeOwner,
		string memory _itemname,
		uint256 qtyToBuy) 
	public 
	onlyMintedStoreOwner(msg.sender) 
	onlyMintedStoreOwner(storeOwner)
	{
		uint256 price; uint256 qtyavail; string memory link;
		(price, qtyavail, link) = _allstores[storeOwner].getOneItem(_itemname);
		require(qtyToBuy > 0, "need to buy 1 or more item");
		require(qtyavail >= qtyToBuy, "cannot buy more than available");

		_transfer(msg.sender, storeOwner, price * qtyToBuy);
		_allstores[storeOwner].setItem(_itemname, price, qtyavail - qtyToBuy, link);
		_ownerships[msg.sender].push(ItemOwnership({store: storeOwner, name: _itemname, qty:qtyToBuy, imagelink: link}));
	}

	function getMyOwnedItem(uint256 index) 
		external
		view onlyMintedStoreOwner(msg.sender)
	returns (
		address,
		string memory,
		uint256,
		string memory)
	{	
		return (
			_ownerships[msg.sender][index].store,
			_ownerships[msg.sender][index].name,
			_ownerships[msg.sender][index].qty,
			_ownerships[msg.sender][index].imagelink
		);
	}

	function getNumberOfItemTransactionDone() 
		external
		view
		onlyMintedStoreOwner(msg.sender)
	returns
		(uint256)
	{
    	return _ownerships[msg.sender].length;
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
