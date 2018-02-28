/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Wednesday, February 28, 2018 12:49 PM
 * @Email:  developer@xyfindables.com
 * @Filename: index.js
 * @Last modified by:   arietrouw
 * @Last modified time: Wednesday, February 28, 2018 1:49 PM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

'use strict';
let debug = require('debug')('xyo-solidity'),
  fs = require('fs'),
  SOLC = require('solc');

class Contracts {
  load(source, contractName) {
    let filename, findImports, input, output;

    filename = `${source}.sol`;
    input = {};
    input[filename] = source;

    findImports = (path) => {
      if (path === 'source.sol') {
        return {
          contents: this.get(path)
        };
      } else {
        return {
          error: 'File not found'
        };
      }
    };

    output = SOLC.compile({
      sources: input
    }, 1, findImports);

    return output.contracts[`${filename}:${contractName}`];
  }

  get(name) {
    fs.readFile(`${__dirname}${name}`, (error, data) => {
      if (error) {
        throw error;
      }
      return data.toString();
    });
  }
}

class XYOSolidity {

  constructor() {
    debug('constructor');
    this.contracts = new Contracts();
  }
}

module.exports = XYOSolidity;
