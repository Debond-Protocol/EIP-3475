// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

import "./ERC3475Upgradable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract ExampleUpgradeableBonds is ERC3475Upgradable, Initializable, OwnableUpgradeable, UUPSUpgradeable {
    bytes32 public constant BANK_ROLE = keccak256("BANK_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    constructor()  {
        _disableInitializers();
    }

    function initialize(IERC3475.Class[] storage classes_, address _bankAddress) initializer public {
        __ERC3475_init(classes_);
        __AccessControl_init();
        __UUPSUpgradeable_init();

        _grantRole(BANK_ROLE,_bankAddress);
        _grantRole(UPGRADER_ROLE, msg.sender);
    }

    function issue(address _to, Transaction[] calldata _transactions)
    external
    virtual
    override(IERC3475)
    onlyRole(BANK_ROLE)
    {
        super.issue(_to, _transactions);
    }


    function  _authorizeUpgrade(address newImplementation)
        internal
        onlyRole(UPGRADER_ROLE)
        override
    {
    }

}


