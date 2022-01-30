// SPDX-License-Identifier: MIT
// This contract will store all listing they are selling

pragma solidity ^0.8.0;

contract C2CMarketCoinStore {
	address payable _storeOwner;
	struct Item { 
		uint256 price; // in C2CMarketCoin
		uint256 qty; // quantity, number of item this have
		string imagelink; //maybe image link to aws s3 or ipfs protocol
		bool isExist; // for checking purpose if item is exist
   	}

   	string[]  private _myitemkeys; //storing item keys for below
   	mapping(string => Item) private  _myitems;

   	constructor(address storeOwner) {
		_storeOwner = payable(storeOwner);
    }

    function getStoreOwner() external view returns (address){
    	return _storeOwner;
    }

   	function setItem(
   		string memory _name,
   		uint256 _price,
   		uint256 _qty,
   		string memory _imagelink
   	) public {
   		if (_myitems[_name].isExist == false){
   			_myitemkeys.push(_name);
   		}
		require(_qty > 0, "need to put 1 more item");
		require(_price > 0 , "price must be equal or more than 0");
		
   		_myitems[_name] = Item({price: _price, qty: _qty, imagelink: _imagelink, isExist: true});
   	}

   	function getOneItem(string memory _name) public view returns (uint256, uint256, string memory) {
   		return (_myitems[_name].price, _myitems[_name].qty, _myitems[_name].imagelink);
   	}

   	function getAllItems() public view returns (string[] memory){
   		return _myitemkeys;
   	}
}