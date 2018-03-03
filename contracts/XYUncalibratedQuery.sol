pragma solidity ^0.4.2;

import './SafeMath.sol';


interface XYUncalibratedQueryNotify {
    function answer(
        address xyoAddress,
        int latitude,
        int longitude,
        int altitude,
        uint accuracy,
        uint certainty,
        uint epoch) external;
}


contract XYUncalibratedQuery {
    using SafeMath for *;

    struct PendingQuery {
        uint xyoValue;
        address xyoAddress;
        uint accuracyThreshold;
        uint certaintyThresold;
        uint minimumDelay;
        uint epoch;
        address xynotify;
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

    event QueryReceived(
        uint xyoValue,
        address xyoAddress,
        uint accuracy,
        uint certainty,
        uint delay,
        uint epoch
        );

    event AnswerReceived(
        address xyoAddress,
        int latitude,
        int longitude,
        int altitude,
        uint accuracy,
        uint certainty,
        uint epoch
        );

    function publishQuery(
        uint _xyoValue,
        address _xyoAddress,
        uint _accuracy,
        uint _certainty,
        uint _delay,
        uint _epoch,
        address _xynotify) public returns(bool) {

        require(_xyoValue > 0);
        pendingQueries[msg.sender] = PendingQuery(
            _xyoValue,
            _xyoAddress,
            _accuracy,
            _certainty,
            _delay,
            _epoch,
            _xynotify);

        QueryReceived(
            _xyoValue,
            _xyoAddress,
            _accuracy,
            _certainty,
            _delay,
            _epoch);

        return true;
    }

    // this is how a diviner sets the answer.  Need to implement the origin proof
    function publishAnswer(
        address _xyoAddress,
        int _latitude,
        int _longitude,
        int _altitude,
        uint _accuracy,
        uint _certainty,
        uint _epoch) public returns(bool) {
        // TODO: Have to verify before returning
        answeredQueries[_xyoAddress] = Answer(
            _xyoAddress, _latitude, _longitude, _altitude, _accuracy, _certainty, _epoch);
        answerList.push(_xyoAddress);
        pendingQueries[msg.sender].xyoValue = 0;
        if (pendingQueries[msg.sender].xynotify != 0) {
            XYUncalibratedQueryNotify(pendingQueries[msg.sender].xynotify).answer(
                _xyoAddress, _latitude, _longitude, _altitude, _accuracy, _certainty, _epoch);
        }
        AnswerReceived(_xyoAddress, _latitude, _longitude, _altitude, _accuracy, _certainty, _epoch);
        return true;
    }

    function hasPendingQuery() view public returns(bool) {
       if(pendingQueries[msg.sender].xyoValue > 0) {
           return true;
       }
       return false;
    }

}
