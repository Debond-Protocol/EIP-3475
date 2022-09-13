

import "../ERC3475.sol";
import "./IERC3475MetadataUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/Initializable.sol";


/// @title ERC3475Upgradable 
/// @author Dhruv Malik
/// @notice this is only example implementation for the developers. the best practice is that Bonds are semi fungible regarding their supply but can update other logic. 
/// @dev reference taken from openzeppelin/contracts-upgreadable architecture.

contract ERC3475Upgradable is ERC3475, IERC3475MetadataUpgradeable, Initializable, ContextUpgradeable {

 struct Nonce {
        mapping(uint256 => IERC3475.Values) _values;

        // stores the values corresponding to the dates (issuance and maturity date).
        mapping(address => uint256) _balances;
        mapping(address => mapping(address => uint256)) _allowances;

        // supplies of this nonce
        uint256 _activeSupply;
        uint256 _burnedSupply;
        uint256 _redeemedSupply;
    }

    /**
     * @notice this Struct is representing the Class properties as an object
     *         and can be retrieved by the classId
     */
    struct Class {
        mapping(uint256 => IERC3475.Values) _values;
        mapping(uint256 => IERC3475.Metadata) _nonceMetadatas;
        mapping(uint256 => Nonce) _nonces;
    }

    mapping(address => mapping(address => bool)) _operatorApprovals;

    // from classId given
    mapping(uint256 => Class) internal _classes;
    mapping(uint256 => IERC3475.Metadata) _classMetadata;


    function __ERC3475_init(Class[] memory classDetails_ ) internal onlyInitializing {
        __ERC3475_init_unchained(classDetails_);

    }

    function __ERC3475_init_unchained(Class[] memory classDetails_) internal onlyInitializing {
        for (uint index = 0; index < classDetails_.length; index++) {
            classes[index] = classDetails_[index];
        }
    }

    function createClassMetadata(uint metadataId, IERC3475.Metadata memory metadata) public view virtual override  {
        classMetadatas[metadataId] = metadata;
    }

    function createClassMetadataBatch(uint[] memory metadataIds, IERC3475.Metadata[] memory metadatas) public view virtual override {
        require(metadataIds.length == metadatas.length, "DebondUpdatable: Incorrect inputs");
        for (uint i; i < metadataIds.length; i++) {
            classMetadatas[metadataIds[i]] = metadatas[i];
        }
    }

    /**
    * @notice create a new metadata for nonces for a given class
    * @dev if the classId given doesn't exist, will revert
    * @param classId the classId
    * @param metadataId the identifier of the metadata being created
    * @param metadata the metadata to create
    */
    function createNonceMetadata(uint classId, uint metadataId, IERC3475.Metadata memory metadata) external onlyBondManager {
        require(classExists(classId), "DebondERC3475: class Id not found");
        classes[classId].nonceMetadatas[metadataId] = metadata;
    }

    /**
    * @notice create metadatas for nonces for a given class
    * @dev if the classId given doesn't exist, will revert
    * @param classId the classId
    * @param metadataIds the identifiers of the metadatas being created
    * @param metadatas the metadatas to create
    */
    function createNonceMetadataBatch(uint classId, uint[] memory metadataIds, IERC3475.Metadata[] memory metadatas) external onlyBondManager {
        require(classExists(classId), "DebondERC3475: class Id not found");
        require(metadataIds.length == metadatas.length, "DebondERC3475: Incorrect inputs");
        for (uint i; i < metadataIds.length; i++) {
            classes[classId].nonceMetadatas[metadataIds[i]] = metadatas[i];
        }
    }
}



