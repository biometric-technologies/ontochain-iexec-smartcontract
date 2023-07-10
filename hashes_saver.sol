// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract HashStorage {
    address private _owner;

    mapping(string => uint256) hashes;

    event NewHash(string[] hash, uint256 date);
    error OwnableInvalidOwner(address owner);

    constructor() {
        _owner = msg.sender;
    }

    modifier onlyOwner{
        require(msg.sender == _owner, "Not the owner");
        _;
    }

    function saveHashes(string[] memory _hashes) onlyOwner public {

        for (uint i=0; i < _hashes.length; i++) {
            require(isExist(_hashes[i]), "Hash already exist.");
            hashes[_hashes[i]] =  block.timestamp;
        }

        emit NewHash(_hashes, block.timestamp);
    }

    function getHashInfo(string memory hash) external view returns (uint256) {
        require(!isExist(hash), "Hash does not exist.");

        return hashes[hash];
    }

    function isExist(string memory hash) private view returns (bool) {
        uint256 index = hashes[hash]; 
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