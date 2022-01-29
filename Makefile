all:
	truffle migrate --reset
	truffle test --show-events