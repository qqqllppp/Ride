// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract Boxie {
    uint256 internal value;

    // Emitted when the stored value changes
    event ValueChanged(uint256 newValue);

    // Stores a new value in the contract
    function store(uint256 newValue) public {
        value = newValue;
        emit ValueChanged(newValue);
    }

    // Reads the last stored value
    function retrieve() public view returns (uint256) {
        return value;
    }

    receive() external payable {}

    fallback() external payable {}
}
