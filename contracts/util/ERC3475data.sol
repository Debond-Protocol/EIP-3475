// SPDX-License-Identifier: MIT


pragma solidity ^0.6.8;

contract ERC3475data {

    mapping(address => mapping(uint256 => mapping(uint256 => uint256))) internal _balances;
    mapping(uint256 => mapping(uint256 => uint256)) internal _activeSupply;
    mapping(uint256 => mapping(uint256 => uint256)) internal _burnedSupply;
    mapping(uint256 => mapping(uint256 => uint256)) internal _redeemedSupply;
    mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256))) internal _nonceInfo;
    mapping (uint256 => address) internal _issuers;
    mapping (uint256 => string) internal _symbols;
    mapping (uint256 => uint256)  internal _lastBondNonces;
    mapping (uint256 => uint256[]) internal _nonces;
    
}
