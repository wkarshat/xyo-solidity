pragma solidity ^0.4.18;

import './XY.sol';
import './Ownable.sol';
import './SafeMath.sol';

contract XYExample is XY, Ownable {
    using SafeMath for *;

    // Implements a use case for the XYO Network
    struct Package {
        uint packageID;
        string xyoAddress;
        uint status; // 0 paid, 1 shipped, 2 delivered
    }

    mapping (address => Package) public packages;
}