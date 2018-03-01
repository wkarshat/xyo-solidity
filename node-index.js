/**
 * @Author: XY | The Findables Company <arietrouw>
 * @Date:   Wednesday, February 28, 2018 12:49 PM
 * @Email:  developer@xyfindables.com
 * @Filename: index.js
 * @Last modified by:   arietrouw
 * @Last modified time: Wednesday, February 28, 2018 3:16 PM
 * @License: All Rights Reserved
 * @Copyright: Copyright XY | The Findables Company
 */

'use strict';
let debug = require('debug')('xyo-solidity'),
  fs = require('fs'),
  SOLC = require('solc');

class Contracts {
  load(filename, contractName) {
    debug('load');
    let findImports, input, output;

    input = {};
    input[filename] = this.get(filename);

    debug('input: ', input);

    findImports = (path) => {
      debug('findImports: ', path);
      return {
        contents: this.get(path)
      };
    };

    output = SOLC.compile({
      sources: input
    }, 1, findImports);

    debug("output: ", output);

    return output.contracts[`${filename}:${contractName}`];
  }

  compile(source, contractName) {
    debug('compile');
    let findImports, input, output;

    input = {};
    input.main = source;

    debug('input: ', input);

    findImports = (path) => {
      debug('findImports: ', path);
      return {
        contents: this.get(path)
      };
    };

    output = SOLC.compile({
      sources: input
    }, 1, findImports);

    debug("output: ", output);

    return output.contracts[`main:${contractName}`];
  }

  get(fileName) {
    debug('get: ', fileName);
    return fs.readFileSync(`${__dirname}/contracts/${fileName}`).toString();
  }
}

class XYOSolidity {

  constructor() {
    debug('constructor');
    this.contracts = new Contracts();
  }
}

module.exports = XYOSolidity;
