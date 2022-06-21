// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC3475.sol";
import "./utils/MathLibrary.sol";

contract ERC3475 is IERC3475, MathLibrary {
    /** example of  description of metadata
    @notice this Struct is representing the Nonce properties as an object
 * and can be retrieve by the nonceId (within a class)
    title : tokenSupplies
    types: uint
    description: storing the state of the supply .
    values : ["_activeSupply", "_burnedSupply", "_redeemedSupply"]
    */
    /**
    title : date Values 
    types: uint
    description: storing the token supply .
    values : ["issuance date ", "maturity date"]
    */
    struct Nonce {
        uint256 nonceId;
        bool exists;
        IERC3475.METADATA tokenSupply;
        IERC3475.METADATA datevalues; // stores the values corresponding to the dates (issuance and maturity date).
        mapping(address => uint256) balances;
        mapping(address => mapping(address => uint256)) allowances;
        address owner;
    }

    /**
     * @notice this Struct is representing the Class properties as an object
     *         and can be retrieve by the classId
     */
    struct Class {
        uint256 classId;
        bool exists;
        string symbol;
        IERC3475.METADATA values; // here for each class we have an array of 2 values: debt token address and period of the bond (6 months or 12 months for example)
        IERC3475.METADATA nonceDescriptions;
        // string[] nonceDescriptions; //that is always integrated in METADATA.

        mapping(address => mapping(address => bool)) operatorApprovals;
        mapping(uint256 => Nonce) nonces; // from nonceId given
    }

    mapping(uint256 => Class) internal classes; // from classId given

    //string[] _classDescriptions;

    IERC3475.METADATA _classDescriptions;

    /**
     * @notice Here the constructor is just to initialize a class and nonce,
     *         in practice you will have a function to create new class and nonce
     */
    constructor() {
        // _classDescriptions.push("Id of token Address");
        // _classDescriptions.push("period of the class");

        _classDescriptions.title = "class descriptions";
        _classDescriptions.types = "string";
        _classDescriptions.description = "identifiers for class details";
        _classDescriptions.values[0] = "Id of token Address";
        _classDescriptions.values[1] = "period of the class";
        // creating class
        Class storage class = classes[0];
        class.classId = 0;
        class.exists = true;
        class.symbol = "DBIT";

        class.values.title = "DBIT  initial and maturity information";
        class.values.types = "uint";
        class
            .values
            .description = "details about issuance and redemption time ";
        class.values.values[0] = "1";
        class.values.values[1] = "180 * 24 * 3600";

        // creating nonce
        Nonce storage nonce = class.nonces[0];
        nonce.nonceId = 0;
        nonce.exists = true;
        nonce.datevalues.title = "timeline information";
        nonce.datevalues.types = "uint";
        nonce.datevalues.description = "maturity date and the intial date";

        uint256 currentTime = block.timestamp;

        nonce.datevalues.values[0] = uintToString(block.timestamp);
        nonce.datevalues.values[1] = uintToString(block.timestamp + 180 days);

        // defining the token supply size based on hwich need to compilation:
        nonce.tokenSupply.title = "storing active , burned and redeemedSupply";
        nonce.tokenSupply.values[0] = uintToString(100000); // current activerSupply
        nonce.tokenSupply.values[1] = uintToString(2000000); // burned
        nonce.tokenSupply.values[2] = uintToString(300000); // redeemedSupply

        class.nonceDescriptions.title = "Nonce descriptions";
        class
            .nonceDescriptions
            .description = "defining Maturity  and issuance date";
        class.nonceDescriptions.values[0] = "Issuance date";
        class.nonceDescriptions.values[1] = "Maturity date";
    }

    // WRITE

    function transferFrom(
        address _from,
        address _to,
        TRANSACTION[] calldata _transaction
    ) public virtual override {
        uint256 len = _transaction.length;

        for (uint256 i = 0; i < len; i++) {
            require(
                msg.sender == _from ||
                    isApprovedFor(_from, msg.sender, _transaction[i].classId),
                "ERC3475:caller-not-owner-or-approved"
            );
            _transferFrom(_from, _to, _transaction);
        }
        emit Transfer(msg.sender, _from, _to, _transaction);
    }

    function issue(address _to, TRANSACTION[] calldata _transaction)
        external
        virtual
        override
    {
        uint256 len = _transaction.length;

        for (uint256 i = 0; i < len; i++) {
            Class storage class = classes[_transaction[i].classId];
            Nonce storage nonce = class.nonces[_transaction[i].nonceId];
            require(classes[i].exists, "ERC3475: BOND-CLASS-NOT-CREATED");
            require(
                _transaction[i].nonceId == nonce.nonceId,
                "Error ERC-3475: nonceId given not found!"
            );
            require(
                _to != address(0),
                "ERC3475: can't transfer to the zero address"
            );
            _issue(_to, _transaction);
        }

        emit Issue(msg.sender, _to, _transaction);
    }

    function redeem(address _from, TRANSACTION[] calldata _transaction)
        external
        virtual
        override
    {
        require(
            _from != address(0),
            "ERC3475: can't transfer to the zero address"
        );
        uint256 len = _transaction.length;
        for (uint256 i = 0; i < len; i++) {
            (, uint256 progressRemaining) = getProgress(
                _transaction[i].classId,
                _transaction[i].nonceId
            );
            require(progressRemaining == 0, "ERC3475 Error: Not redeemable");
            _redeem(_from, _transaction);
        }
        emit Redeem(msg.sender, _from, _transaction);
    }

    function burn(address _from, TRANSACTION[] calldata _transaction)
        external
        virtual
        override
    {
        require(
            _from != address(0),
            "ERC3475: can't transfer to the zero address"
        );
        _burn(_from, _transaction);
        emit Burn(msg.sender, _from, _transaction);
    }

    function approve(address _spender, TRANSACTION[] calldata _transaction)
        external
        virtual
        override
    {
        for (uint256 i = 0; i < _transaction.length; i++) {
            require(
                msg.sender ==
                    classes[_transaction[i].classId]
                        .nonces[_transaction[i].nonceId]
                        .owner,
                "only owner can approve the transfer"
            );
            classes[_transaction[i].classId]
                .nonces[_transaction[i].nonceId]
                .allowances[msg.sender][_spender] = _transaction[i]._amount;
        }
    }

    function setApprovalFor(
        address operator,
        uint256 classId,
        bool approved
    ) public virtual override {
        // TODO: implementing internal function for setting approval.
        classes[classId].operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalFor(msg.sender, operator, classId, approved);
    }

    // READS
    // IERC3475.METADATA tokenSupply;
    // IERC3475.METADATA datevalues; // stores the values corresponding to the dates (issuance and maturity date).

    function totalSupply(uint256 classId, uint256 nonceId)
        public
        view
        override
        returns (uint256)
    {
        return (activeSupply(classId, nonceId) +
            burnedSupply(classId, nonceId) +
            redeemedSupply(classId, nonceId));
    }

    function activeSupply(uint256 classId, uint256 nonceId)
        public
        view
        override
        returns (uint256)
    {
        (uint256 _activeSupply, ) = strToUint(
            classes[classId].nonces[nonceId].tokenSupply.values[0]
        );
        return _activeSupply;
    }

    function burnedSupply(uint256 classId, uint256 nonceId)
        public
        view
        override
        returns (uint256)
    {
        (uint256 _burnedSupply, ) = strToUint(
            classes[classId].nonces[nonceId].tokenSupply.values[2]
        );
        return _burnedSupply;
    }

    function redeemedSupply(uint256 classId, uint256 nonceId)
        public
        view
        override
        returns (uint256)
    {
        (uint256 _redeemSupply, ) = strToUint(
            classes[classId].nonces[nonceId].tokenSupply.values[1]
        );
        return _redeemSupply;
    }

    function balanceOf(
        address account,
        uint256 classId,
        uint256 nonceId
    ) public view override returns (uint256) {
        require(
            account != address(0),
            "ERC3475: balance query for the zero address"
        );
        return classes[classId].nonces[nonceId].balances[account];
    }

    /**
    @dev here the classValues are stored in the single array as being described on the 
    
     */
    function classValues(uint256 classId)
        public
        view
        override
        returns (uint256[] memory)
    {
        uint256[] memory classValue;
        Class storage class = classes[classId];

        for (uint256 i = 0; i < class.values.values.length; i++) {
            (classValue[i], ) = strToUint(classes[classId].values.values[i]);
        }
        return classValue;
    }

    function classDescriptions()
        external
        view
        returns (IERC3475.METADATA calldata)
    {
        return _classDescriptions;
    }

    function nonceValues(uint256 classId, uint256 nonceId)
        public
        view
        override
        returns (uint256[] memory)
    {
        // we need to present both the tokenSupply along with the date information.
        return classes[classId].values;
    }

    function nonceDescriptions(uint256 classId)
        external
        view
        returns (string[] memory)
    {

        string[] memory  nonceReturn = new string[](classes[classId].nonceDescriptions.values.length);
        //uint length = classes[classId].nonceDescription;

        for(uint i = 0; i < classes[classId].nonceDescriptions.values.length; i++)
        return  nonceReturn.push(classes[classId].nonceDescriptions.values[i]);
    }

    /**
     * @notice ProgressAchieved and progressRemaining is abstract, here for the example we are giving time passed and time remaining.
     */
    function getProgress(uint256 classId, uint256 nonceId)
        public
        view
        override
        returns (uint256 progressAchieved, uint256 progressRemaining)
    {
        (uint256 issuanceDate,) = strToUint(
            classes[classId].nonces[nonceId].datevalues.values[0]
        );
        (uint256 maturityDate,) = strToUint(classes[classId].nonces[nonceId].datevalues.values[1]);
        progressAchieved = block.timestamp > issuanceDate
            ? block.timestamp - issuanceDate
            : 0;
        progressRemaining = block.timestamp < maturityDate
            ? maturityDate - block.timestamp
            : 0;
    }

    function allowance(
        address owner,
        address spender,
        uint256 classId,
        uint256 nonceId
    ) external view returns (uint256) {
        require(
            owner == classes[classId].nonces[nonceId].owner,
            "only  the owner can get allowance"
        );
        return classes[classId].nonces[nonceId].allowances[owner][spender];
    }

    function isApprovedFor(
        address owner,
        address operator,
        uint256 classId
    ) public view virtual override returns (bool) {
        //require(owner == classes[classId].) TODO: generally this is the function implemented by the bank contract for allowing the approval for the whole class.
        return classes[classId].operatorApprovals[owner][operator];
    }

    /**
    @dev here the information is stored in series in the pairs  of 2   
    (first struct corresponding to the start is values about supply and corresponding information is the nonceDescription ).
     */
    function classMetadata() external view returns (METADATA[] memory) {
        //defining the  metadata for value and the dates seperately
        METADATA[] memory returnMetadata;
        for (uint256 i = 0; i < classes.length; i++) {
            returnMetadata[i].push(classes[i].values);
            returnMetadata[i].push(classes[i].nonceDescriptions);
        }
        return (returnMetadata);
    }

    /**
    IERC3475.METADATA tokenSupply;
        IERC3475.METADATA datevalues;
    
     */
    function nonceMetadata(uint256 classId)
        external
        view
        returns (METADATA[] memory)
    {
        METADATA[] memory returnMetadata;
        Nonce storage nonce = classes[classId].nonces;
        for (uint256 i = 0; i < classes.length; i++) {
            returnMetadata[i].push(nonce.tokenSupply);
            returnMetadata[i].push(nonce.datevalues);
        }
    }

    function _transferFrom(
        address from,
        address to,
        IERC3475.TRANSACTION[] calldata _transactions
    ) private {
        require(
            from != address(0),
            "ERC3475: can't transfer from the zero address"
        );
        require(
            to != address(0),
            "ERC3475: can't transfer to the zero address"
        );
        require(
            classes[_transactions.classId]
                .nonces[_transactions.nonceId]
                .balances[_transactions.from] >= _transactions._amount,
            "ERC3475: not enough bond to transfer"
        );
        _transfer(from, to, _transactions);
    }

    function _transfer(
        address from,
        address to,
        IERC3475.TRANSACTION[] calldata _transactions
    ) private {
        require(from != to, "ERC3475: can't transfer to the same address");
        classes[_transactions.classId].nonces[_transactions.nonceId].balances[
                _transactions.from
            ] -= _transactions._amount;
        classes[_transactions.classId].nonces[_transactions.nonceId].balances[
                _transactions.to
            ] += _transactions._amount;
    }

    function _issue(address to, IERC3475.TRANSACTION[] calldata _transaction)
        private
    {
        classes[_transaction.classId].nonces[_transaction.nonceId].balances[
                to
            ] += _transaction._amount;
        classes[_transaction.classId]
            .nonces[_transaction.nonceId]
            ._activeSupply += _transaction._amount;
    }

    function _redeem(
        address _from,
        IERC3475.TRANSACTION[] calldata _transaction
    ) private {
        require(
            classes[_transaction.classId].nonces[_transaction.nonceId].balances[
                _transaction._from
            ] >= _transaction._amount
        );
        classes[_transaction.classId].nonces[_transaction.nonceId].balances[
                _transaction._from
            ] -= _transaction._amount;
        classes[_transaction.classId]
            .nonces[_transaction.nonceId]
            ._activeSupply -= _transaction._amount;
        classes[_transaction.classId]
            .nonces[_transaction.nonceId]
            ._redeemedSupply += _transaction._amount;
    }

    function _burn(address _from, IERC3475.TRANSACTION[] calldata _transaction)
        private
    {
        require(
            classes[_transaction.classId].nonces[_transaction.nonceId].balances[
                _from
            ] >= _transaction._amount
        );
        classes[_transaction.classId].nonces[_transaction.nonceId].balances[
                _from
            ] -= _transaction._amount;
        classes[_transaction.classId]
            .nonces[_transaction.nonceId]
            ._activeSupply -= _transaction._amount;
        classes[_transaction.classId]
            .nonces[_transaction.nonceId]
            ._burnedSupply += _transaction._amount;
    }
}
