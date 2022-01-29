pragma solidity ^0.8.0;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

contract C2CMarketCoinERC20 is IERC20 {
	mapping (address => uint256) internal _balances;
	uint256 internal _totalSupply;

	function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        return true;
    }

	function allowance(address owner, address spender) external view override returns (uint256) {
        return 0;
    }   

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        return true;
    }
}