// SPDX-License-Identifier: GPL-3.0

pragma solidity =0.8.29;

contract SimpleBank {
    // key: 0xuseraddress
    // value: balance
    mapping(address user => uint256 balance) public balance;

    // total supply
    uint256 public totalSupply;

    // Custom errors
    error InvalidAmount(uint256 amount, uint256 currentUserBalance);

    // Events
    event Deposited(address indexed from, uint256 amount);
    event Withdrawn(address indexed from, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);

    function name() public pure returns (string memory) {
        return "SimpleBank";
    }

    function symbol() public pure returns (string memory) {
        return "SBANK";
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function deposit() external payable { // payable identifica che é in grado di ricevere ether
        balances[msg.sender] += msg.value;
        totalSupply += msg.value;
        emit Deposited(msg.sender, recipient, msg.value);
    }

    function withdraw(uint256 amount) external {
        uint256 currentUserBalance = balances[msg.sender];
        require(0 <amount && amount <= balances[msg.sender], InvalidAmount(amount, currentUserBalance));
        // PRIMA aggiorniamo il balance 
        balances[msg.sender] -= amount;
        // POI tiriamo fuori ETH dal contract
        payable(msg.sender).transfer(amount);

    }

    function transfer(address recipient, uint256 amount) external {
        uint256 currentUserBalance = balances[msg.sender];

        require(0 < amount && amount <= currentUserBalance, InvalidAmount(amount, currentUserBalance));

        balances[msg.sender] -= amount;
        balances[recipient] += amount;
    }
}

contract ComplicatedBank is SimpleBank {
//
}