//SDPX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Box is Ownable {
    uint256 private s_value;

    event ValueChanged(uint256 newValue);

    constructor() Ownable(msg.sender) {}

    function store(uint256 newValue) public onlyOwner {
        s_value = newValue;
        emit ValueChanged(newValue);
    }

    function getValue() public view returns (uint256) {
        return s_value;
    }
}
