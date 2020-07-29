pragma solidity ^0.5.8;

contract Purchase {
    uint public value;
    address payable public seller;
    address payable public buyer;
    
    enum State { Created, Locked, Inactive } State public state;
    
    constructor() public payable {
        seller = msg.sender;
        value = msg.value / 2;
        
        require((2 * value) == msg.value, "Value has to be even.");
    }
    
    modifier condition(bool _condition) {
        require(_condition);
        _;
    }
    
    modifier onlyBuyer() {
        require(buyer == msg.sender , "Only buyer can call this.");
        _;
    }
    
    modifier onlySeller() {
        require(seller == msg.sender , "Only seller can call this.");
        _;
    }
    
    modifier inState(State _state) {
        require(state == _state, "Invalid state.");
        _;
    }
    
    event Aborted();
    event PurchaseConfirmed();
    event ItemReceived();
    
    function abort() public onlySeller inState(State.Created) payable{
        emit Aborted();
        state = State.Inactive;
        seller.transfer(address(this).balance);
    }
    
    function confirmPurchase() public inState(State.Created) condition(msg.value == (2 * value)) payable {
        emit PurchaseConfirmed();
        buyer = msg.sender;
        state = State.Locked;
    }
    
    function confirmReceived() public onlyBuyer inState(State.Locked) payable{
        emit ItemReceived();
        
        state = State.Inactive;
        buyer.transfer(value);
        seller.transfer(address(this).balance);
    } 
}