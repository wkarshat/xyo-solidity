pragma solidity ^0.4.18;

import './XY.sol';
import './Ownable.sol';
import './SafeMath.sol';

contract XYExample is Ownable {
    using SafeMath for *;

    enum ShippingStatus { Paid, Shipped, Delivered }
    // Implements a use case for the XYO Network
    struct Package {
        uint packageID;
        address xyoAddress;
        ShippingStatus status;
    }

    uint public numPackages;
    mapping (address => Package) public packages;

    // Orders and stores a package with an xyoAddress in this contract and
    // transfers the balance to this XYExample contract
    function orderPackage(address _xyoAddress) public payable returns(uint) {
        require(_xyoAddress != address(0));
        numPackages = numPackages + 1;
        // transfers the payment to the owner contract
        owner.transfer(msg.value);
        packages[msg.sender] = Package(numPackages, _xyoAddress, ShippingStatus.Paid);
        return numPackages;
    }

    // Tracks a packge by publishing a pending query to the XYO Contract that will
    // be answered by trusted diviner oracles from the XYO Network with a certain accuracy
    // threshold. Returns false if package is pending, true otherwise.
    function trackPackage(
        string _accuracyThreshold,
        string _certaintyThreshold,
        string _certaintyThreshold,
        string _delay,
        string _epoch) public payable returns(bool) {
        // Creates an XY instance with the XYO contract address
        XY xy = XY(/* Deployed XY Address */)
        // If we still have a pending query then we return nothing
        if (xy.hasPendingQuery()) {
            return false;
        }
        xy.publishQuery(msg.value, packages[msg.sender].xyoAddress, _accuracyThreshold, _certaintyThreshold, _delay, _epoch);
        return true;
    }
}
