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
        address xyoAddress;
        int latitude;
        int longitude;
        int altitude;
        uint accuracy;
        uint certainty;
        uint epoch;
    }

    // Stores a mapping of pending queries
    mapping (address => PendingQuery) public pendingQueries;
    // Stores a mapping of xyoAddresses to answers
    mapping (address => Answer) public answeredQueries;
    address[] public answerList;

    event QueryReceived(uint xyoValue, address xyoAddress, uint accuracy, uint certainty, uint delay, uint epoch);
    event AnswerReceived(address xyoAddress, int latitude, int longitude, int altitude, uint accuracy, uint certainty, uint epoch);

    function publishQuery(uint _xyoValue, address _xyoAddress, uint _accuracy, uint _certainty, uint _delay, uint _epoch) public returns(bool) {
        require(_xyoValue > 0);
        QueryReceived(_xyoValue, _xyoAddress, _accuracy, _certainty, _delay, _epoch);
        pendingQueries[msg.sender] = PendingQuery(_xyoValue, _xyoAddress, _accuracy, _certainty, _delay, _epoch);
        return true;
    }

    function publishAnswer(address _xyoAddress, int _latitude, int _longitude, int _altitude, uint _accuracy, uint _certainty, uint _epoch) public returns(bool) {
        // TODO: Have to verify before returning
        AnswerReceived(_xyoAddress, _latitude, _longitude, _altitude, _accuracy, _certainty, _epoch);
        answeredQueries[_xyoAddress] = Answer(_xyoAddress, _latitude, _longitude, _altitude, _accuracy, _certainty, _epoch);
        answerList.push(_xyoAddress);
        pendingQueries[msg.sender].xyoValue = 0;
        return true;
    }

    function hasPendingQuery() view public returns(bool) {
       if(pendingQueries[msg.sender].xyoValue > 0) {
           return true;
       }
       return false;
    }

}
