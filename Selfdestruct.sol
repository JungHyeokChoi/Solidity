pragma solidity ^0.5.0;

contract Destruct {
    string public text;
    
    constructor() public{
        text = "Destroy Test";
    }
    
    function setText(string memory _text) public {
        text = _text;
    }
    
    function destroy() public payable{
        selfdestruct(msg.sender);
    }
}