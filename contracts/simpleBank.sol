// SPDX-License-Identifier: MIT

pragma solidity =0.8.29;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract SimpleBank is IERC20 {
    // key: 0xuseraddress
    // value: balance 
    mapping(address user => uint256 balance) public balanceOf;
    uint256 public totalSupply;
    
    mapping(address owner => mapping(address spender => uint256 allowance)) public allowance;

    // Custom Errors
    error InvalidAmount(uint256 amount, uint256 currentUserBalance);

    // Function modifiers:
    
    // private
    // internal
    // public
    // external

    // Events
    event Deposited(address indexed from, address indexed to, uint256 amount);
    event Withdrawn(address indexed from, uint256 amount);

    function name() public pure returns (string memory) {
        return "Simple Bank";
    }

    function symbol() public pure returns (string memory) {
        return "SBANK";
    }

    function decimals() public pure returns (uint8) {   
        return 18;
    }

    function _mint(address _account)  internal {
        balanceOf[_account] += msg.value;
        totalSupply += msg.value;
    }
    // function _burn() 

    function deposit() external payable {
        // balanceOf[_account] += msg.value;
        // totalSupply += msg.value;
        _mint(msg.sender);
        emit Deposited(msg.sender, msg.sender, msg.value);
    }

    function depositFor(address recipient) external payable {
        // balanceOf[recipient] += msg.value;
        // totalSupply += msg.value;
        _mint(recipient);
        emit Deposited(msg.sender, recipient, msg.value);
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        uint256 currentUserBalance = balanceOf[msg.sender];
        require(_value <= currentUserBalance, InvalidAmount(_value, currentUserBalance));
        currentUserBalance -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        success = true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        allowance[msg.sender][_spender] = _value; 
        return true;
    }

    // tx.origin !== msg.sender
    // tx.origin rappresenta l'EOA che ha fatto il broadcast della transazione
    // msg.sender può essere il contratto che chiama il metodo del nostro ERC20

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {

        uint256 senderBalance = balanceOf[_from];
        uint256 recipientAllowance = allowance[_from][msg.sender];

        // Non è detto che msg.sender sia il destinatario del trasferimento 
        // MA deve avere l'autorizzazione per effettuare il trasferimento.

        require(_value <= senderBalance && _value <= recipientAllowance, InvalidAmount(_value, allowance[_from][_to]));

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(_from, _to, _value);
    }

    function withdraw(uint256 amount) external {
        // Checks, effects, interaction
        // INIZIALMENTE verifichiamo i prerequisiti
        uint256 currentUserBalance = balanceOf[msg.sender];
        require(0 < amount && amount <= currentUserBalance, InvalidAmount(amount, currentUserBalance));
        // DOPODICHÉ aggiorniamo il balance
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        // INFINE preleviamo ETH dal contratto
        payable(msg.sender).transfer(amount);
        // Emettiamo l'evento
        emit Withdrawn(msg.sender, amount);
    }
}