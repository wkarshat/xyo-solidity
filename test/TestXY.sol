pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/XY.sol";

contract TestXY {

  function testHasPendingQuery() public {
    XY xy = XY(DeployedAddresses.XY());
    Assert.equal(xy.hasPendingQuery(), false, 'owner should not have pending query');
  }

  function testPublishQuery() public {
    XY xy = XY(DeployedAddresses.XY());
    uint xyoValue = 5;
    address xyoAddress = tx.origin;
    uint accuracy = 90;
    uint certainty = 90;
    uint delay = 0;
    uint epoch = 0;
    address xynotify = 0;
    xy.publishQuery(xyoValue, xyoAddress, accuracy, certainty, delay, epoch, xynotify);
    Assert.equal(xy.hasPendingQuery(), true, 'owner should have pending query');
  }


}
