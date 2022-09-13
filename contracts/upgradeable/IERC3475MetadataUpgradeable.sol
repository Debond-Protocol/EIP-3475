pragma solidity ^0.8.9;

import "../IERC3475.sol";
interface IERC3475MetadataUpgradeable  {


    /**
    * @notice create a new metadata for classes on the actual bond contract
    * @param metadataId the identifier of the metadata being created
    * @param metadata the metadata to create
    */
    function createClassMetadata(uint metadataId, IERC3475.Metadata memory metadata) external;


    /**
    * @notice create a new metadata for classes on the actual bond contract
    * @param metadataIds the identifiers of the metadatas being created
    * @param metadatas the metadatas to create
    */
    function createClassMetadataBatch(uint[] memory metadataIds, IERC3475.Metadata[] memory metadatas) external;


    /**
    * @notice create a new metadata for nonces for a given class
    * @dev if the classId given doesn't exist, will revert
    * @param classId the classId
    * @param metadataId the identifier of the metadata being created
    * @param metadata the metadata to create
    */
    function createNonceMetadata(uint classId, uint metadataId, IERC3475.Metadata memory metadata) external;

    /**
    * @notice create metadatas for nonces for a given class
    * @dev if the classId given doesn't exist, will revert
    * @param classId the classId
    * @param metadataIds the identifiers of the metadatas being created
    * @param metadatas the metadatas to create
    */
    function createNonceMetadataBatch(uint classId, uint[] memory metadataIds, IERC3475.Metadata[] memory metadatas) external;
}