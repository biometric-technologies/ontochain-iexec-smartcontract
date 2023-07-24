// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HashStorage {
    address private _owner;

    mapping(string => HashStruct) public hashes;

    event NewHash(HashStruct[] hash);

    struct HashStruct {
        string hash;
        uint256 timestamp;
        string loanId;
    }

    error OwnableInvalidOwner(address owner);

    constructor() {
        _owner = msg.sender;
    }

    modifier onlyOwner{
        require(msg.sender == _owner, "Not the owner");
        _;
    }

    function saveHashes(HashStruct[] memory _hashes) onlyOwner public {

        for (uint i=0; i < _hashes.length; i++) {
            require(isExist(_hashes[i].hash), "Hash already exist.");
            hashes[_hashes[i].hash] = HashStruct(_hashes[i].hash, _hashes[i].timestamp, _hashes[i].loanId);
        }

        emit NewHash(_hashes);
    }

    function getHashInfo(string memory hash) external view returns (HashStruct memory) {
        require(!isExist(hash), "Hash does not exist.");

        return hashes[hash];
    }

    function isExist(string memory hash) private view returns (bool) {
        uint256 index = hashes[hash].timestamp; 
        return index == 0;
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        _owner = newOwner;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

}