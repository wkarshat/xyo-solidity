/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Wednesday, February 28, 2018 2:11 PM
 * @Email:  developer@xyfindables.com
 * @Filename: node-test.js
 * @Last modified by:   arietrouw
 * @Last modified time: Wednesday, February 28, 2018 2:59 PM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

'use strict';
const debug = require('debug')('node-test'),
  XYOSolidity = require('./node-index.js'),
  test = () => {
    debug('test');
    let solidity, compiled;

    solidity = new XYOSolidity();
    compiled = solidity.contracts.load('xy.sol', 'XY');

    debug('result: ', compiled);
  };

test();
