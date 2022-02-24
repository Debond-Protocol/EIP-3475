// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import ".././ERC3475.sol";

contract Bond is ERC3475 {

    function createBond(uint256 classId, address tokenAddress, string memory _symbol) external {
        createClass(classId, tokenAddress, _symbol);
    }
}
