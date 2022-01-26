pragma solidity ^0.6.8;
import "./util/IERC20.sol";
import "./util/IERC3475.sol";
import "./util/ITestToken.sol";
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

interface ITestBank {
  
    function setContract(uint256 class, address token_contract_address,address bond_contract_address) external returns (bool);
    function buyBond(address input_token, address _to, uint256 amount_USD_in) external returns (bool);
    function redeemBond(address _from, address _to, uint256 class, uint256[] calldata nonce, uint256[] calldata _amount) external returns (bool);
    
}

contract TestBank is ITestBank{
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    mapping (uint256 => address) public token_contract;
    address public bond_contract;
    address public dev_address;
   
    constructor () public {
        dev_address = msg.sender;
    }
    
      
    function setContract(uint256 class, address token_contract_address,address bond_contract_address) external override returns (bool) {
        require(msg.sender==dev_address);
        token_contract[class] = token_contract_address;
        bond_contract = bond_contract_address;
        return (true);
    }
    
    function buyBond(address input_token, address _to, uint256 amount_USD_in) external override returns (bool){
        uint256 amount_bond_out = amount_USD_in*2;
        require(IERC20(input_token).transferFrom(msg.sender, address(this), amount_USD_in),'Not enough deposit.');
        IERC3475(bond_contract).issueBond(_to, 0, amount_bond_out);
        return(true);
    }
    
  
    function redeemBond(address _from, address _to, uint256 class, uint256[] calldata nonce, uint256[] calldata _amount) external override returns (bool){
    assert( IERC3475(bond_contract).redeemBond(_from, class, nonce, _amount));
    uint256 amount_token_mint;
    for (uint i=0; i<_amount.length; i++){
        amount_token_mint+=_amount[i];
        }
    ITestToken(token_contract[class]).mint(_to,amount_token_mint);
    return(true);      
    }
    
}
