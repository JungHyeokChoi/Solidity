pragma solidity ^0.5.8;

contract Lottery{
    address payable public manager;
    address payable[] public players;
    
    constructor() public {
        manager = msg.sender;
    }
    
    function enter() public payable {
        require(msg.value >= .01 ether);
        players.push(msg.sender);
    }
    
    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(now, msg.sender, players.length)));
    }
    
    function pickWinner() public restricted {
        uint index = random() % players.length;
        players[index].transfer(address(this).balance);
        players = new address payable[](0);
    }
    
    function getPlayers() public view returns(address payable[] memory) {
        return players;
    }
    
    modifier restricted {
        require(manager == msg.sender);
        _;
    }
}