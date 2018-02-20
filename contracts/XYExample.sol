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

    mapping (address => Package) public packages;

    // Tracks a packge by publishing a pending query to the XYO Contract that will
    // be answered by trusted diviner oracles from the XYO Network
    function trackPackage() view public returns(Answer) {
        // If we still have a pending query then we return nothing
        if (hasPendingQuery()) {
            return;
        }
        // fetch package, get its xyoAddress and fetch its answer
        return answeredQueries[packages[msg.sender].xyoAddress];
    }
}