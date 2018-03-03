pragma solidity ^0.4.2;

import './SafeMath.sol';


interface XYCalibratedQueryNotify {
    function answer(
        address xyoAddress,
        int latitude,
        int longitude,
        int altitude,
        uint accuracy,
        uint certainty,
        uint epoch) external;
}


contract XYCalibratedQuery {
    using SafeMath for *;

    struct PendingQuery {
        uint xyoValue;
        address xyoAddress;
        uint accuracyThreshold;
        uint certaintyThresold;
        uint minimumDelay;
        uint epoch;
        address calibrationAddress;
        int calibrationLatitude;
        int calibrationLongitude;
        int calibrationAltitude;
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
        uint epoch,
        address calibrationAddress,
        int calibrationLatitude,
        int calibrationLongitude,
        int calibrationAltitude
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
        address _calibrationAddress,
        int _calibrationLatitude,
        int _calibrationLongitude,
        int _calibrationAltitude,
        address _xynotify) public returns(bool) {

        require(_xyoValue > 0);
        pendingQueries[msg.sender] = PendingQuery(
            _xyoValue,
            _xyoAddress,
            _accuracy,
            _certainty,
            _delay,
            _epoch,
            _calibrationAddress,
            _calibrationLatitude,
            _calibrationLongitude,
            _calibrationAltitude,
            _xynotify);

        QueryReceived(
            _xyoValue,
            _xyoAddress,
            _accuracy,
            _certainty,
            _delay,
            _epoch,
            _calibrationAddress,
            _calibrationLatitude,
            _calibrationLongitude,
            _calibrationAltitude);

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
            XYCalibratedQueryNotify(pendingQueries[msg.sender].xynotify).answer(
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
