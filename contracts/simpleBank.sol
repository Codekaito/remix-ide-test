// SPDX-License-Identifier: GPL-3.0

pragma solidity =0.8.29;

contract SimpleBank {
    // key: 0xuseraddress
    // value: balance
    mapping(address => uint256) public balances;

    error InvalidAmount(uint256 amount);

    function deposit() external payable { // payable identifica che é in grado di ricevere ether
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(0 <amount && amount <= balances[msg.sender], InvalidAmount(amount));

        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);

    }
}

contract ComplicatedBank is SimpleBank {

}