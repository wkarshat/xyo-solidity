pragma solidity ^0.4.2;

import './SafeMath.sol';

contract XY {
    using SafeMath for *;

    struct PendingQuery {
        uint xyoValue;
        address xyoAddress;
        uint accuracyThreshold;
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

    event QueryReceived(uint xyoValue, address xyoAddress, uint accuracy);
    event AnswerReceived(address divinerAddress, string lat, string lng);

    function publishQuery(uint _xyoValue, address _xyoAddress, uint _accuracy) public returns(bool) {
        require(_xyoValue > 0);
        QueryReceived(_xyoValue, _xyoAddress, _accuracy);
        pendingQueries[msg.sender] = PendingQuery(_xyoValue, _xyoAddress, _accuracy);
        return true;
    }

    function hasPendingQuery() view public returns(bool) {
       if(pendingQueries[msg.sender].xyoValue > 0) {
           return true;
       }
       return false;
    }

    // Receive an answer to a query from an oracle
    // TODO: needs to be trusted based on oracle signatures
    function receiveQuery() public returns(bool) {
      return true;
    }
}
