pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/XY.sol";

contract TestXY {

  function testInitialBalanceUsingDeployedContract() public {

    uint expected = 10000;
    Assert.equal(10000, expected, "Owner should have 10000 MetaCoin initially");
  }


}
