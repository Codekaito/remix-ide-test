// SPDX-License-Identifier: GPL-3.0

pragma solidity =0.8.29;

contract SimpleBank {
    // key: 0xuseraddress
    // value: balance
    mapping(address => uint256) public balances;

    function deposit() public payable { // payable identifica che é in grado di ricevere ether
        balances[msg.sender] += msg.value;
    }
}