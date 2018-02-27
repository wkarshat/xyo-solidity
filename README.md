# XY Oracle Network Smart Contract API

Library toolkit for developing dApps connected to the XY Oracle Network. Users can subscribe to webhooks for event listeners from the XY contract using https://if-eth.com.

## Requirements

Installing Ganache as a local, Ethereum blockchain node:

* Make sure you have Node.js installed, then run `npm install -g ganache-cli`
* Then, run `ganache-cli`. It will start a local Ethereum simulation on port 8545.

Now that you have Ganache, you can clone the xyo-solidity repo and deploy the XY
core smart contract to the local node as follows:

* Install truffle with `npm i truffle -g`
* Clone the xyo-solidity repo `git clone https://github.com/XYOracleNetwork/xyo-solidity`
* While ganache is running, compile and deploy the contract: `truffle compile && truffle migrate`
* You should see the following in your command line:

![Truffle Migrate](https://i.imgur.com/zfa7YjL.png)

You can also run the simple unit tests over the XY.sol file with `truffle test`
