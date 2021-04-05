pragma solidity ^0.6.8;


interface ITestToken {
    function setContract(address contract_address) external returns (bool);
    
    function mint(address _to, uint256 _amount) external returns (bool);
}