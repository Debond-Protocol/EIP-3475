// SPDX-License-Identifier: MIT


pragma solidity ^0.6.8;

import "./IERC3475.sol";
import "./ERC3475data.sol";

contract ERC3475 is IERC3475, ERC3475data {

    mapping(uint256 => uint256)  private _Fibonacci_number;
    mapping(uint256 => uint256)  private _Fibonacci_epoch;
    mapping(uint256 => uint256)  private _genesis_nonce_time;

    constructor() public {
        _Fibonacci_number[0] = 8;
        _Fibonacci_epoch[0] = 1;
        _genesis_nonce_time[0] = 0;
    }

    function totalSupply(uint256 class, uint256 nonce) public override view returns (uint256) {

        return _activeSupply[class][nonce] + _burnedSupply[class][nonce] + _redeemedSupply[class][nonce];
    }

    function activeSupply(uint256 class, uint256 nonce) public override view returns (uint256) {

        return _activeSupply[class][nonce];
    }

    function burnedSupply(uint256 class, uint256 nonce) public override view returns (uint256) {

        return _burnedSupply[class][nonce];
    }

    function redeemedSupply(uint256 class, uint256 nonce) public override view returns (uint256) {

        return _redeemedSupply[class][nonce];
    }

    function balanceOf(address account, uint256 class, uint256 nonce) public override view returns (uint256){
        require(account != address(0), "ERC659: balance query for the zero address");

        return _balances[account][class][nonce];
    }

    function getBondSymbol(uint256 class) view public override returns (string memory){

        return _symbols[class];
    }

    function getBondInfo(uint256 class, uint256 nonce) public view override returns (string memory bondSymbol, uint256 timestamp, uint256 info2, uint256 info3, uint256 info4, uint256 info5, uint256 info6) {
        bondSymbol = _symbols[class];
        timestamp = _nonceInfo[class][nonce][1];
        info2 = _nonceInfo[class][nonce][2];
        info3 = _nonceInfo[class][nonce][3];
        info4 = _nonceInfo[class][nonce][4];
        info5 = _nonceInfo[class][nonce][5];
        info6 = _nonceInfo[class][nonce][6];
    }

    function bondIsRedeemable(uint256 class, uint256 nonce) public override view returns (bool) {// TODO we need to know the domain of that function, if it is general

        if (uint(_nonceInfo[class][nonce][1]) < now) {
            uint256 total_liquidity;
            uint256 needed_liquidity;
            //uint256 available_liquidity;

            for (uint i = 0; i <= _lastBondNonces[class]; i++) {
                total_liquidity += _activeSupply[class][i] + _redeemedSupply[class][i];
            }

            for (uint i = 0; i <= nonce; i++) {
                needed_liquidity += (_activeSupply[class][i] + _redeemedSupply[class][i]) * 2;
            }

            if (total_liquidity >= needed_liquidity) {

                return (true);

            }

            else {
                return (false);
            }
        }

        else {
            return (false);
        }


    }



    function burnBond(address _from, uint256[] calldata class, uint256[] calldata nonce, uint256[] calldata _amount) external override {
        // insuring the caller is legitimate  for the given class.
        for (uint n = 0; n < nonce.length; n++) {
            require(msg.sender == _issuers[class[n]] || msg.sender == _from, "ERC3475: operator unauthorized");
            require(_balances[_from][class[n]][nonce[n]] >= _amount[n], "ERC3475: insufficient bonds to burn");
            require(_burnBond(_from, class[n], nonce[n], _amount[n]));
        }
    }


    function issueBond(address _to, uint256 class, uint256 _amount) external override {
        //require(msg.sender==_bankAddress[class], "ERC659: operator unauthorized");
        require(_to != address(0), "ERC659: issue bond to the zero address");
        require(_amount >= 100, "ERC659: invalid amount");
        if (_genesis_nonce_time[class] == 0) {
            _genesis_nonce_time[class] = now - now % _Fibonacci_epoch[class];
        }
        uint256 now_nonce = (now - _genesis_nonce_time[class]) / _Fibonacci_epoch[class];
        uint256 FibonacciTimeEponge0 = 1;
        uint256 FibonacciTimeEponge1 = 2;
        uint256 FibonacciTimeEponge;
        uint256 amount_out_eponge;
        for (uint i = 0; i < _Fibonacci_number[class]; i++) {
            if (i == 0) {FibonacciTimeEponge = 1;}
            else {
                if (i == 1) {FibonacciTimeEponge = 2;}
                else {
                    FibonacciTimeEponge = (FibonacciTimeEponge0 + FibonacciTimeEponge1);
                    FibonacciTimeEponge0 = FibonacciTimeEponge1;
                    FibonacciTimeEponge1 = FibonacciTimeEponge;

                }
            }
            amount_out_eponge += FibonacciTimeEponge;
        }

        amount_out_eponge = _amount * 1e3 / amount_out_eponge;
        FibonacciTimeEponge = 0;
        FibonacciTimeEponge0 = 1;
        FibonacciTimeEponge1 = 2;
        for (uint i = 0; i < _Fibonacci_number[class]; i++) {
            if (i == 0) {FibonacciTimeEponge = 1;}
            else {
                if (i == 1) {FibonacciTimeEponge = 2;}
                else {
                    FibonacciTimeEponge = (FibonacciTimeEponge0 + FibonacciTimeEponge1);
                    FibonacciTimeEponge0 = FibonacciTimeEponge1;
                    FibonacciTimeEponge1 = FibonacciTimeEponge;
                }
            }
            require(_issueBond(_to, class, now_nonce + FibonacciTimeEponge, amount_out_eponge * FibonacciTimeEponge / 1e3) == true);
        }
    }


    function redeemBond(address _from, uint256 class, uint256[] calldata nonce, uint256[] calldata _amount) external override {
        require(msg.sender == _issuers[class] || msg.sender == _from, "ERC659: operator unauthorized");
        for (uint i = 0; i < nonce.length; i++) {
            require(_balances[_from][class][nonce[i]] >= _amount[i], "ERC659: not enough bond for redemption");
            require(bondIsRedeemable(class, nonce[i]) == true, "ERC659: can't redeem bond before it's redemption day");
            require(_redeemBond(_from, class, nonce[i], _amount[i]));
        }

    }

    function transferBond(address _from, address _to, uint256[] calldata class, uint256[] calldata nonce, uint256[] calldata _amount) external override {

        for (uint n = 0; n < nonce.length; n++) {
            require(msg.sender == _issuers[class[n]] || msg.sender == _from, "ERC659: operator unauthorized");
            require(_balances[_from][class[n]][nonce[n]] >= _amount[n], "ERC659: not enough bond to transfer");
            require(_to != address(0), "ERC659: cant't transfer to zero bond, use 'burnBond()' instead");
            require(_transferBond(_from, _to, class[n], nonce[n], _amount[n]));
        }
    }

    function _issueBond(address _to, uint256 class, uint256 nonce, uint256 _amount) private returns (bool) {


        if (totalSupply(class, nonce) == 0) {
            _createBond(_to, class, nonce, _amount);
            return (true);
        }

        else {

            _balances[_to][class][nonce] += _amount;
            _activeSupply[class][nonce] += _amount;
            emit eventIssueBond(msg.sender, _to, class, _lastBondNonces[class], _amount);
            return (true);
        }
    }

    function _createBond(address _to, uint256 class, uint256 nonce, uint256 _amount) private {

        if (_lastBondNonces[class] < nonce) {
            _lastBondNonces[class] = nonce;
        }
        _nonces[class].push(nonce);
        _nonceInfo[class][nonce][1] = _genesis_nonce_time[class] + (nonce) * _Fibonacci_epoch[class];
        // TODO here we are missing nonce informations at creation
        _balances[_to][class][nonce] += _amount;
        _activeSupply[class][nonce] += _amount;
        emit eventIssueBond(msg.sender, _to, class, nonce, _amount);
    }

    function _redeemBond(address _from, uint256 class, uint256 nonce, uint256 _amount) private returns (bool) {

        _balances[_from][class][nonce] -= _amount;
        _activeSupply[class][nonce] -= _amount;
        _redeemedSupply[class][nonce] += _amount;
        emit eventRedeemBond(msg.sender, _from, class, nonce, _amount);
        return (true);
    }

    function _transferBond(address _from, address _to, uint256 class, uint256 nonce, uint256 _amount) private returns (bool){
        _balances[_from][class][nonce] -= _amount;
        _balances[_to][class][nonce] += _amount;
        emit eventTransferBond(msg.sender, _from, _to, class, nonce, _amount);
        return (true);

    }

    function _burnBond(address _from, uint256 class, uint256 nonce, uint256 _amount) private returns (bool){
        _balances[_from][class][nonce] -= _amount;
        _burnedSupply[class][nonce] += _amount;
        emit eventBurnBond(msg.sender, _from, class, nonce, _amount);
        return (true);

    }

}
