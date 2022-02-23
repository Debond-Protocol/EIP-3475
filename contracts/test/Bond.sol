// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import ".././ERC3475.sol";

contract Bond is ERC3475 {

    function createBond(address tokenA, address tokenB, string memory _symbol) external {
        createClass(tokenA, tokenB, _symbol);
    }
}
