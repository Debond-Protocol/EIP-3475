pragma solidity ^0.6.8;

contract ERC3475data {
    mapping (address => mapping( uint256 =>mapping(uint256=> uint256))) public _balances;
    
    mapping (uint256 => mapping(uint256 => uint256)) public _activeSupply;
    
    mapping (uint256 => mapping(uint256 => uint256)) public _burnedSupply;
  
    mapping (uint256 => mapping(uint256 => uint256)) public _redeemedSupply;

    mapping (uint256 => address) public _bankAddress;
    
    mapping (uint256 => string) public _Symbol;
    
    mapping (uint256 => mapping(uint256=> mapping(uint256=> uint256))) public _info;

    mapping (uint256 => uint256)  public last_bond_nonce;
    
    mapping (uint256 => uint256[]) public _nonceCreated;
    
}
