pragma solidity ^0.4.2;

import './SafeMath.sol';


interface XYRelativeQueryNotify {
    function answer(
        address xyoAddress,
        uint range,
        uint accuracy,
        uint certainty,
        uint epoch) external;
}


contract XYRelativeQuery {
    using SafeMath for *;

    struct PendingQuery {
        uint xyoValue;
        address xyoAddress;
        uint accuracyThreshold;
        uint certaintyThresold;
        uint minimumDelay;
        uint epoch;
        address relativeAddress;
        address xynotify;
    }

    struct Answer {
        address xyoAddress;
        uint range;
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
        uint epoch,
        address relativeAddress
        );

    event AnswerReceived(
        address xyoAddress,
        uint range,
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
        address _relativeAddress,
        address _xynotify) public returns(bool) {

        require(_xyoValue > 0);
        pendingQueries[msg.sender] = PendingQuery(
            _xyoValue,
            _xyoAddress,
            _accuracy,
            _certainty,
            _delay,
            _epoch,
            _relativeAddress,
            _xynotify);

        QueryReceived(
            _xyoValue,
            _xyoAddress,
            _accuracy,
            _certainty,
            _delay,
            _epoch,
            _relativeAddress);

        return true;
    }

    // this is how a diviner sets the answer.  Need to implement the origin proof
    function publishAnswer(
        address _xyoAddress,
        uint _range,
        uint _accuracy,
        uint _certainty,
        uint _epoch) public returns(bool) {
        // TODO: Have to verify before returning
        answeredQueries[_xyoAddress] = Answer(
            _xyoAddress, _range, _accuracy, _certainty, _epoch);
        answerList.push(_xyoAddress);
        pendingQueries[msg.sender].xyoValue = 0;
        if (pendingQueries[msg.sender].xynotify != 0) {
            XYRelativeQueryNotify(pendingQueries[msg.sender].xynotify).answer(
                _xyoAddress, _range, _accuracy, _certainty, _epoch);
        }
        AnswerReceived(_xyoAddress, _range, _accuracy, _certainty, _epoch);
        return true;
    }

    function hasPendingQuery() view public returns(bool) {
       if(pendingQueries[msg.sender].xyoValue > 0) {
           return true;
       }
       return false;
    }

}
