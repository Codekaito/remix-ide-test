// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Storage {
    uint256 number; // slot 0 // 32 bytes
    address immutable deployer;

    constructor() {
        deployer = msg.sender;
    }

    function store(uint256 num) public {
        number = num;
    }

    function retrieve() public view returns (uint256){ // 
        return number;
    }

    function getDeployerAddress() public view returns(address) {
        return deployer;
    }
}