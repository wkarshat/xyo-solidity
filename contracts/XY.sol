pragma solidity ^0.4.18;

import './SafeMath.sol';

contract XY {
    using SafeMath for *;

    struct PendingQuery {
        uint xyoValue;
        address xyoAddress;
        string accuracyThreshold;
    }

    struct Answer {
        string accuracyScore;
        string lat;
        string lng;
    }

    // Stores an internal mapping of pending queries
    mapping (address => PendingQuery) pendingQueries;
    // Stores an internal mapping of xyoAddresses to answers
    mapping (address => Answer) answeredQueries;

    event AnswerReceived(address divinerAddress, string lat, string long);

    function publishQuery(uint _xyoValue, address _xyoAddress, string _accuracy) public returns(PendingQuery) {
        require(_xyoValue > 0);
        return pendingQueries[msg.sender] = PendingQuery(_xyoValue, _xyoAddress, _accuracy);
    }

    function hasPendingQuery() view public returns(bool) {
       if (pendingQueries[msg.sender].xyoValue > 0) {
           return true;
       }
       return false;
    }
     // Receive query function from oracle that receives an answer
}