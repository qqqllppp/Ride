// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract Box3 {
    uint256 private value;

    // Emitted when the stored value changes
    event ValueChanged(uint256 indexed newValue);

    // Stores a new value in the contract
    function store3(uint256 newValue) public {
        value = newValue;
        emit ValueChanged(newValue);
    }

    // Stores a new value in the contract
    function store32(uint256 newValue) public {
        value = newValue;
        emit ValueChanged(newValue);
    }

    // Reads the last stored value
    function retrieve3() public view returns (uint256) {
        return value;
    }
}
