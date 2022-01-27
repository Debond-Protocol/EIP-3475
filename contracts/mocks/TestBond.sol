pragma solidity ^0.6.2;
import "../util/IERC3475.sol";
import "../util/SafeMath.sol";
import "../util/ERC3475data.sol";
// SPDX-License-Identifier: apache 2.0
/*
*/

contract TestBond is IERC3475, ERC3475data{
    

    struct bondDetails {
        string  name;

    }


    mapping (uint256 => uint256)  public _Fibonacci_number;
    mapping (uint256 => uint256)  public _Fibonacci_epoch;
    mapping (uint256 => uint256)  public _genesis_nonce_time;
    
    address public dev_address=msg.sender;
   


    constructor (string _bondSymbol , uint _initFibonaccinumb , uint _initFibonacciEpoch , uint _genesis_nonce_time ) public {
        
        _Symbol[0]= _bondSymbol;
        _Fibonacci_number[0]= 8;
        _Fibonacci_epoch[0]=1;
        _genesis_nonce_time[0]=0;
        
    }
    
    function setBond(uint256 class, address  bank_contract)public override returns (bool) {
        require(msg.sender==dev_address, "ERC3475: operator unauthorized");
        _bankAddress[class]=bank_contract;
        return true;
    }   
    
   
    function createBondClass(uint256 class, address bank_contract, string memory bond_symbol, uint256 Fibonacci_number, uint256 Fibonacci_epoch)public returns (bool) {
        require(msg.sender==dev_address, "ERC3475: operator unauthorized");
        _Symbol[class]=bond_symbol;
        _bankAddress[class]=bank_contract;
        _Fibonacci_number[class]=Fibonacci_number;
        _Fibonacci_epoch[class]=Fibonacci_epoch;
        _genesis_nonce_time[class]=0;
        return true;
    }   





    function getNonceCreated(uint256 class) public override view returns (uint256[] memory){
        return _nonceCreated[class];
    }
 
    function totalSupply( uint256 class, uint256 nonce) public override view returns (uint256) {
    
       return _activeSupply[class][nonce]+_burnedSupply[class][nonce]+_redeemedSupply[class][nonce];
    }
    function activeSupply( uint256 class, uint256 nonce) public override view returns (uint256) {
    
       return _activeSupply[class][nonce];
    }
    function burnedSupply( uint256 class, uint256 nonce) public override view  returns (uint256) {
    
        return _burnedSupply[class][nonce];
    }
    function redeemedSupply(  uint256 class, uint256 nonce) public override view  returns (uint256) {
    
        return _redeemedSupply[class][nonce];
    }
    function balanceOf(address account, uint256 class, uint256 nonce) public override view returns (uint256){
        require(account != address(0), "ERC3475: balance query for the zero address");
        return _balances[account][class][nonce];
    }
    function getBondSymbol(uint256 class) view public override returns (string memory){
        
        return _Symbol[class]; 
    }     
    function getBondInfo(uint256 class, uint256 nonce) public view override returns (string memory BondSymbol, uint256 timestamp, uint256 info2, uint256 info3, uint256 info4, uint256 info5,uint256 info6) {
        BondSymbol=_Symbol[class];
        timestamp=_info[class][nonce][1];
        info2=_info[class][nonce][2];
        info3=_info[class][nonce][3];
        info4=_info[class][nonce][4];
        info5=_info[class][nonce][5];
        info6=_info[class][nonce][6];
    } 
    function bondIsRedeemable(uint256 class, uint256 nonce) public override view returns (bool){
        
        if(uint(_info[class][nonce][1])<now){
            uint256 total_liquidity;
            uint256 needed_liquidity;
            //uint256 available_liquidity;
    
            for (uint i=0; i<=last_bond_nonce[class]; i++) {
                total_liquidity += _activeSupply[class][i]+_redeemedSupply[class][i];
                }
            
            for (uint i=0; i<=nonce; i++) {
                needed_liquidity += (_activeSupply[class][i]+_redeemedSupply[class][i])*2;
                }
                
            if(total_liquidity>=needed_liquidity){
               
                return(true);
                
                }
            
            else{
                return(false);
            }
         }
         
    else{
            return(false);
        }

             
         }
         
    function _createBond(address _to, uint256 class, uint256 nonce, uint256 _amount) private returns(bool) {
    
        if(last_bond_nonce[class]<nonce)
        {last_bond_nonce[class]=nonce;}
        _nonceCreated[class].push(nonce);
        _info[class][nonce][1]=_genesis_nonce_time[class] + (nonce) * _Fibonacci_epoch[class];
        _balances[_to][class][nonce]+=_amount;
        _activeSupply[class][nonce]+=_amount;
        emit eventIssueBond(msg.sender, _to, class,nonce, _amount);
        return(true);
    }
    function _issueBond(address _to, uint256 class, uint256 nonce, uint256 _amount) private returns(bool) {
       
       
        if (totalSupply(class,nonce)==0){
            _createBond(_to,class,nonce,_amount);
            return(true);
            }
            
        else{
            
            _balances[_to][class][nonce]+=_amount;
            _activeSupply[class][nonce]+=_amount;
            emit eventIssueBond(msg.sender, _to, class,last_bond_nonce[class], _amount);
            return(true);
            }
    }    
    function _redeemBond(address _from, uint256 class, uint256 nonce, uint256 _amount) private returns(bool) {
       
        _balances[_from][class][nonce]-=_amount;
        _activeSupply[class][nonce]-=_amount;
        _redeemedSupply[class][nonce]+=_amount;
        emit eventRedeemBond( msg.sender,_from, class, nonce, _amount);
        return(true);
    }    
    function _transferBond(address _from, address _to, uint256 class, uint256 nonce, uint256 _amount) private returns(bool){      
        _balances[_from][class][nonce]-=_amount;
        _balances[_to][class][nonce]+=_amount;
        emit eventTransferBond( msg.sender,_from,_to, class, nonce, _amount);
        return(true);
    
            }
    function _burnBond(address _from, uint256 class, uint256 nonce, uint256 _amount) private returns(bool){      
        _balances[_from][class][nonce]-=_amount;
        emit eventBurnBond( msg.sender,_from, class, nonce, _amount);
        return(true);
    
            }
            
    function issueBond(address _to, uint256  class, uint256 _amount) external override returns(bool){
        //require(msg.sender==_bankAddress[class], "ERC3475: operator unauthorized");
        require(_to != address(0), "ERC3475: issue bond to the zero address");
        require(_amount >= 100, "ERC3475: invalid amount");
        //TODO: 
        if(_genesis_nonce_time[class]==0){_genesis_nonce_time[class]= now-now % _Fibonacci_epoch[class];}
        uint256  now_nonce=(now-_genesis_nonce_time[class])/_Fibonacci_epoch[class];
        uint256 FibonacciTimeEponge0=1;
        uint256 FibonacciTimeEponge1=2;
        uint256 FibonacciTimeEponge;
        uint256 amount_out_eponge;
        for (uint i=0; i<_Fibonacci_number[class]; i++) {
            if(i==0){FibonacciTimeEponge=1;}
            else{
                if(i==1){FibonacciTimeEponge=2;}
                else{
                    FibonacciTimeEponge=(FibonacciTimeEponge0+FibonacciTimeEponge1);
                    FibonacciTimeEponge0=FibonacciTimeEponge1;
                    FibonacciTimeEponge1=FibonacciTimeEponge;
                    
            }
        }   
            amount_out_eponge+=FibonacciTimeEponge;     
}
        
        amount_out_eponge=_amount*1e3/amount_out_eponge;
        FibonacciTimeEponge=0;
        FibonacciTimeEponge0=1;
        FibonacciTimeEponge1=2;
        for (uint i=0; i<_Fibonacci_number[class]; i++) {
            if(i==0){FibonacciTimeEponge=1;}
            else{
                if(i==1){FibonacciTimeEponge=2;}
                else{
                    FibonacciTimeEponge=(FibonacciTimeEponge0+FibonacciTimeEponge1);
                    FibonacciTimeEponge0=FibonacciTimeEponge1;
                    FibonacciTimeEponge1=FibonacciTimeEponge;
            }
        }   
            require(_issueBond( _to, class, now_nonce + FibonacciTimeEponge, amount_out_eponge * FibonacciTimeEponge/1e3) == true);
    }    
      return(true);
}
    function redeemBond(address _from, uint256 class, uint256[] calldata nonce, uint256[] calldata  _amount) external override returns(bool){
        require(msg.sender==_bankAddress[class] || msg.sender==_from, "ERC3475: operator unauthorized");
        for (uint i=0; i<nonce.length; i++) {
            require(_balances[_from][class][nonce[i]] >= _amount[i], "ERC3475: not enough bond for redemption");
            require(bondIsRedeemable(class,nonce[i])==true, "ERC3475: can't redeem bond before it's redemption day");
            require(_redeemBond(_from,class,nonce[i],_amount[i]));
        }
        
        return(true);

       
        }
    function transferBond(address _from, address _to, uint256[] calldata class, uint256[] calldata nonce, uint256[] calldata _amount) external override returns(bool){ 
        
        for (uint n=0; n<nonce.length; n++) {
            require(msg.sender==_bankAddress[class[n]] || msg.sender==_from, "ERC3475: operator unauthorized");
            require(_balances[_from][class[n]][nonce[n]] >= _amount[n], "ERC3475: not enough bond to transfer");
            require(_to!=address(0), "ERC3475: cant't transfer to zero bond, use 'burnBond()' instead");
            require(_transferBond(_from, _to, class[n], nonce[n], _amount[n]));
           
            
        }
        return(true);
    }
    function burnBond(address _from, uint256[] calldata class, uint256[] calldata nonce, uint256[] calldata _amount) external override returns(bool){
   
        for (uint n=0; n<nonce.length; n++) {
            require(msg.sender==_bankAddress[class[n]] || msg.sender==_from, "ERC3475: operator unauthorized");
            require(_balances[_from][class[n]][nonce[n]] >= _amount[n], "ERC3475: not enough bond to burn");
            require(_burnBond(_from, class[n], nonce[n], _amount[n]));
           
            
        }
        return(true);
    }
}