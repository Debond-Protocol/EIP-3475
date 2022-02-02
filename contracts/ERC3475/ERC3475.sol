// SPDX-License-Identifier: MIT


pragma solidity ^0.6.8;

import "./IERC3475.sol";

contract ERC3475 is IERC3475 {

    mapping(address => mapping(uint256 => mapping(uint256 => uint256))) private _balances;
    mapping(uint256 => mapping(uint256 => uint256)) private _activeSupply;
    mapping(uint256 => mapping(uint256 => uint256)) private _burnedSupply;
    mapping(uint256 => mapping(uint256 => uint256)) private _redeemedSupply;
    mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256))) private _nonceInfo;
    mapping (uint256 => string) private _symbols;
    mapping (uint256 => uint256)  private _lastBondNonces;
    mapping (uint256 => uint256[]) private _nonces;


    mapping(address => mapping(uint256 => mapping(uint256 => mapping(address => bool)))) private _operatorApprovals;





    // needed to issue Bonds??
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
        require(account != address(0), "ERC3475: balance query for the zero address");

        return _balances[account][class][nonce];
    }

    function symbol(uint256 class) view public override returns (string memory){

        return _symbols[class];
    }

    function infos(uint256 class, uint256 nonce) public view override returns (string memory _symbol, uint256 _timestamp, uint256 _info2, uint256 _info3, uint256 _info4, uint256 _info5, uint256 _info6) {
        _symbol = _symbols[class];
        _timestamp = _nonceInfo[class][nonce][1];
        _info2 = _nonceInfo[class][nonce][2];
        _info3 = _nonceInfo[class][nonce][3];
        _info4 = _nonceInfo[class][nonce][4];
        _info5 = _nonceInfo[class][nonce][5];
        _info6 = _nonceInfo[class][nonce][6];
    }

    function isRedeemable(uint256 class, uint256 nonce) public override view returns (bool) {


        // TODO !!define implementation is Redeemable!!
        if (uint(_nonceInfo[class][nonce][1]) < now) { // TODO a nounce creation Date can be in the future?
            uint256 total_liquidity;
            uint256 needed_liquidity;
            //uint256 available_liquidity;

            for (uint i = 0; i <= _lastBondNonces[class]; i++) { // TODO are we trying to loop into all nounces of a classId
                total_liquidity += _activeSupply[class][i] + _redeemedSupply[class][i];
            }

            for (uint i = 0; i <= nonce; i++) {
                needed_liquidity += (_activeSupply[class][i] + _redeemedSupply[class][i]) * 2; // TODO to define!!
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

    function isApprovedFor(address _account, address _operator, uint256 _class, uint256 _nonce) public view virtual override returns (bool) {
        return _operatorApprovals[_account][_class][_nonce][_operator];
    }

    function transferFrom(address _from, address _to, uint256 _class, uint256 _nonce, uint256 _amount) public virtual override {
        require(msg.sender == _from || isApprovedFor(_from, msg.sender, _class, _nonce), "ERC3475: caller is not owner nor approved");
        _transferFrom(_from, _to, _class, _nonce, _amount);
        emit TransferSingle(msg.sender, _from, _to, _class, _nonce, _amount);
    }

    function batchTransferFrom(address _from, address _to, uint256[] memory classes, uint256[] memory nonces, uint256[] memory _amounts) public virtual override {
        require(msg.sender == _from || batchIsApprovedFor(_from, msg.sender, classes, nonces), "ERC3475: caller is not owner nor approved");
        _batchTransferFrom(_from, _to, classes, nonces, _amounts);
        emit TransferBatch(msg.sender, _from, _to, classes, nonces, _amounts);
    }

    function batchIsApprovedFor(address _account, address _operator, uint256[] memory classes, uint256[] memory nonces) public view virtual override returns (bool) {
        require(classes.length == nonces.length, "ERC3475: _classes and _nonces length mismatch");
        for (uint i = 0; i < classes.length; i++) {
            if (!_operatorApprovals[_account][classes[i]][nonces[i]][_operator]) {
                return false;
            }
        }
        return true;
    }

    function setApprovalFor(address _operator, uint256[] memory _classes, uint256[] memory nonces, bool _approved) public virtual override {
        require(_classes.length == nonces.length, "ERC3475: _classes and _nonces length mismatch");
        for (uint i = 0; i < _classes.length; i++) {
            _operatorApprovals[msg.sender][_classes[i]][nonces[i]][_operator] = _approved;
        }
    }

    function issueBond(address _to, uint256 class, uint256 _amount) internal virtual {
        require(_to != address(0), "ERC659: issue bond to the zero address");
        require(_amount >= 100, "ERC659: invalid amount"); // TODO determine why amount needs to be greater than 100 ???

        uint256 now_nonce = _generateNewNonce(class);


        // TODO We need to determine the logic for all this computation, refactoring is mandatory, no magic values!!
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
            _issueBond(_to, class, now_nonce + FibonacciTimeEponge, amount_out_eponge * FibonacciTimeEponge / 1e3);
        }
    }

    function _issueBond(address _to, uint256 class, uint256 nonce, uint256 _amount) private {
        // TODO are we trying to check if a bond exists ?? totalSupply is not the right way to check that!!
        if (totalSupply(class, nonce) == 0) {
            _createBond(class, nonce);
        }
        _balances[_to][class][nonce] += _amount;
        _activeSupply[class][nonce] += _amount;
    }

    function _createBond(uint256 class, uint256 nonce) private {

        if (_lastBondNonces[class] < nonce) {
            _lastBondNonces[class] = nonce;
        }
        _nonces[class].push(nonce);
        _nonceInfo[class][nonce][1] = _genesis_nonce_time[class] + (nonce) * _Fibonacci_epoch[class];
        // TODO here we are missing nonce informations at creation
    }


    function redeemBond(address _from, uint256 class, uint256[] memory nonces, uint256[] memory _amounts) internal virtual {
        require(nonces.length == _amounts.length, "ERC3475: _amounts and _nonces length mismatch");
        for (uint i = 0; i < nonces.length; i++) {
            require(isRedeemable(class, nonces[i]) == true, "ERC3475: can't redeem bond before it's redemption day");
            _redeemBond(_from, class, nonces[i], _amounts[i]);
        }
    }

    function _redeemBond(address _from, uint256 class, uint256 nonce, uint256 _amount) private {
        require(_balances[_from][class][nonce] >= _amount, "ERC3475: not enough bond for redemption");
        _balances[_from][class][nonce] -= _amount;
        _activeSupply[class][nonce] -= _amount;
        _redeemedSupply[class][nonce] += _amount;
    }

    function _transfer(address _from, address _to, uint256 class, uint256 nonce, uint256 _amount) private {
        _balances[_from][class][nonce] -= _amount;
        _balances[_to][class][nonce] += _amount;
    }

    function _transferFrom(address _from, address _to, uint256 class, uint256 nonce, uint256 _amount) private {
        require(_from != address(0), "ERC3475: can't transfer from the zero address");
        require(_to != address(0), "ERC3475: can't transfer to the zero address");
        require(_balances[_from][class][nonce] >= _amount, "ERC3475: not enough bond to transfer");
        _transfer(_from, _to, class, nonce, _amount);
    }

    function _batchTransferFrom(address _from, address _to, uint256[] memory classes, uint256[] memory nonces, uint256[] memory _amounts) private {
        require(classes.length == nonces.length && classes.length == _amounts.length , "ERC3475: classes, nonces and amounts length mismatch");
        require(_from != address(0), "ERC3475: can't transfer from the zero address");
        require(_to != address(0), "ERC3475: can't transfer to the zero address");
        for (uint i = 0; i < nonces.length; i++) {
            require(_balances[_from][classes[i]][nonces[i]] >= _amounts[i], "ERC3475: not enough bond to transfer");
            _transfer(_from, _to, classes[i], nonces[i], _amounts[i]);
        }
        emit TransferBatch(msg.sender, _from, _to, classes, nonces, _amounts);
    }

    function burnBond(address _from, uint256[] memory classes, uint256[] memory nonces, uint256[] memory _amounts) internal virtual {
        require(classes.length == nonces.length && classes.length == _amounts.length , "ERC3475: classes, nonces and amounts length mismatch");
        require(_from != address(0), "ERC3475: can't transfer from the zero address");
        for (uint i = 0; i < classes.length; i++) {
            require(_balances[_from][classes[i]][nonces[i]] >= _amounts[i], "ERC3475: insufficient bonds to burn");
            _burnBond(_from, classes[i], nonces[i], _amounts[i]);
        }
    }

    function _burnBond(address _from, uint256 class, uint256 nonce, uint256 _amount) private {
        _balances[_from][class][nonce] -= _amount;
        _burnedSupply[class][nonce] += _amount;

    }

    function _generateNewNonce(uint256 class) private returns (uint256) {
        if (_genesis_nonce_time[class] == 0) {
            _genesis_nonce_time[class] = now - now % _Fibonacci_epoch[class];
        }
       return (now - _genesis_nonce_time[class]) / _Fibonacci_epoch[class];
    }

}
