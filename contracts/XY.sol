pragma solidity ^0.4.2;

import './SafeMath.sol';

contract XY {
    using SafeMath for *;

    struct PendingQuery {
        uint xyoValue;
        address xyoAddress;
        uint accuracyThreshold;
        uint certaintyThresold;
        uint minimumDelay;
        uint epoch;
    }

    struct Answer {
        string accuracyScore;
        string certaintyScore;
        string lat;
        string lng;
        string alt;
    }

    // Stores an internal mapping of pending queries
    mapping (address => PendingQuery) pendingQueries;
    // Stores an internal mapping of xyoAddresses to answers
    mapping (address => Answer) answeredQueries;

    event QueryReceived(uint xyoValue, address xyoAddress, uint accuracy, uint certainty, uint delay, uint epoch);
    event AnswerReceived(address divinerAddress, string lat, string lng);

    function publishQuery(uint _xyoValue, address _xyoAddress, uint _accuracy, uint _certainty, uint _delay, uint _epoch) public returns(bool) {
        require(_xyoValue > 0);
        QueryReceived(_xyoValue, _xyoAddress, _accuracy, _certainty, _delay, _epoch);
        pendingQueries[msg.sender] = PendingQuery(_xyoValue, _xyoAddress, _accuracy, _certainty, _delay, _epoch);
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
    function receiveQuery() public pure returns(bool) {
      return true;
    }
}
