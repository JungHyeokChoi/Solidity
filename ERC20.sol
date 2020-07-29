// SPDX-License-Identifier : minutes
pragma solidity >=0.4.0 < 0.7.0;

/*
   This contract is for testing on remix
   When using this contract, delete Sender contract and replace Sender.owner with msg.sender before use.
*/

contract Sender {
    address internal owner;
    
    constructor() public {
        owner = msg.sender;
    }
    
    function updateOwner(address newOwner) public returns (bool) {
        require(msg.sender == owner, "Only current owner can update owner");
        owner = newOwner;
        
        return true;
    }
    
    function getOwner() public view returns (address) {
        return owner;
    }
}

contract ERC20 is Sender{
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) public {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = (_totalSupply * (10 ** uint(_decimals)));
        balances[Sender.owner] = totalSupply;
    }
    
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }
    
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balances[Sender.owner] >= _value, "Sender.owner balances are less than value");
        
        balances[Sender.owner] = balances[Sender.owner] - _value;
        balances[_to] = balances[_to] + _value;
        
        emit Transfer(Sender.owner, _to, _value);
        
        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool) {
        require(balances[Sender.owner] >= _value, "Sender.owner balances are less than value");
        
        allowed[Sender.owner][_spender] = _value;
        
        emit Approval(Sender.owner, _spender, _value);
        
        return true;
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_from > address(0), "From address is 0");       
        require(_to > address(0), "To address is 0");
        require(Sender.owner == _to, "To is not this contract owner");
        require(balances[_from] >= _value, "From's balances are less than value");
        require(allowed[_from][Sender.owner] >= _value, "From's and To's allowed value are less than value");
        
        balances[_from] = balances[_from] - _value;
        balances[_to] = balances[_to] + _value;
        
        allowed[_from][Sender.owner] = allowed[_from][Sender.owner] - _value;
        
        emit Transfer(_from, _to, _value);
        
        return true;
    }
}