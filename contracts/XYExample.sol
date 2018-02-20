pragma solidity ^0.4.18;

import './XY.sol';
import './Ownable.sol';
import './SafeMath.sol';

contract XYExample is XY, Ownable {
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
        this.balance = msg.value;
        packages[msg.sender] = Package(numPackages, _xyoAddress, ShippingStatus.Paid);
        return numPackages;
    }

    // Tracks a packge by publishing a pending query to the XYO Contract that will
    // be answered by trusted diviner oracles from the XYO Network with a certain accuracy
    // threshold
    function trackPackage(string _accuracyThreshold) public payable {
        // If we still have a pending query then we return nothing
        if (hasPendingQuery()) {
            return;
        }
        publishQuery(msg.value, packages[msg.sender].xyoAddress, _accuracyThreshold);
        return;
    }
}