pragma solidity ^0.6.2;

import "./library/SafeMath.sol";
import "./ERC3475/ERC3475.sol";
// SPDX-License-Identifier: apache 2.0
/*
    Copyright 2020 Sigmoid Foundation <info@SGM.finance>

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

contract TestBond is ERC3475 {


    address public dev_address = msg.sender;



    constructor () public {

        _symbols[0] = "SASH-USD Bond";

    }

//    function setBond(uint256 class, address  bank_contract)public override returns (bool) {
//        require(msg.sender==dev_address, "ERC659: operator unauthorized");
//        _bankAddress[class]=bank_contract;
//        return true;
//    }
    // note: the below functiion  was orignally  defined as override but there has no inherited class

    function getNonceCreated(uint256 class) public view returns (uint256[] memory){
        return _nonces[class];
    }

//    function createBondClass(uint256 class, address bank_contract, string memory bond_symbol, uint256 Fibonacci_number, uint256 Fibonacci_epoch) public returns (bool) {
//        require(msg.sender == dev_address, "ERC659: operator unauthorized");
//        _symbols[class] = bond_symbol;
//        _issuers[class] = bank_contract;
//        _Fibonacci_number[class] = Fibonacci_number;
//        _Fibonacci_epoch[class] = Fibonacci_epoch;
//        _genesis_nonce_time[class] = 0;
//        return true;
//    }
}
