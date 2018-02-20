pragma solidity ^0.4.18;

import './SafeMath.sol';

contract XY {
    using SafeMath for *;

    struct PendingQuery {
        uint xyoValue;
        string xyoAddress;
        uint accuracyThreshold;
    }
    // Stores an internal mapping of pending queries
    mapping (address => PendingQuery) internal pendingQueries;

    function publishQuery(uint _xyoValue, string _xyoAddress, uint _accuracy) public returns(PendingQuery) {
        require(_xyoValue > 0);
        require(_accuracy > 50);
        return pendingQueries[msg.sender] = PendingQuery(_xyoValue, _xyoAddress, _accuracy);
    }

     // Receive query function from oracle that receives an answer
}