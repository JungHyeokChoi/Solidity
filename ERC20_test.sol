pragma solidity >=0.4.22 <0.7.0;
import "remix_tests.sol";
import "remix_accounts.sol";
import "ERC20.sol";

// address(this) : Contract account
// acc0 : user account

contract ERC20_test{
    string name = "MyToken";
    string symbol = "BT";
    uint8 decimals = 2;
    uint256 totalSupply = 10000;
    
    ERC20 erc20;
    
    address acc0;

    function beforeAll() public {
        acc0 = TestsAccounts.getAccount(0);
    }
    
    function beforeEach() public {
        erc20 = new ERC20(name, symbol, decimals, totalSupply);
    }
    
    function checkValue() public {
        Assert.equal(erc20.name(), name, "Name should be same");
        Assert.equal(erc20.symbol(), symbol, "Symbol should be same");
        Assert.equal(erc20.decimals(), uint(decimals), "Decimals should be same");
    }
    
    function checkInvaildValue() public {
        Assert.notEqual(erc20.name(), "wrongToken", "Name should not be same");
        Assert.notEqual(erc20.symbol(), "wrongSymbol", "Symbol should not be same");
        Assert.notEqual(erc20.decimals(), uint(0), "Decimals should not be same");
    }
    
    function checkTotalSupply() public {
        Assert.equal(erc20.totalSupply(), (totalSupply * (10 ** uint(decimals))), "Invalid totalSupply");
    }
    
    function checkBalaanceOf() public {
        Assert.notEqual(erc20.balanceOf(address(this)), totalSupply, "Invalid balance");
    }
    
    function checkTransfer() public {
        Assert.ok(erc20.transfer(acc0, 10000), "Transfer from address(this) to acc0.");
        Assert.equal(erc20.balanceOf(address(this)), 990000, "The balance of address(this) is 990000 BT.");
        Assert.equal(erc20.balanceOf(acc0), 10000, "The balance of acc0 is 10000 BT.");
    }
    
    function checkApprove() public {
        Assert.ok(erc20.approve(acc0, 10000), "Approve from address(this) to acc0 10000 BT.");
        Assert.equal(erc20.allowance(address(this), acc0), 10000, "The allowance acc0 received by address(this) is 10000 BT.");
    }
    
    function checkTransferFrom() public {
        Assert.ok(erc20.getOwner() == address(this), "Current Owner is address(this).");
        Assert.equal(erc20.balanceOf(address(this)), 1000000, "The balance of address(this) is 1000000 BT.");
        Assert.equal(erc20.balanceOf(acc0), 0, "The balance of acc0 is 0 BT.");

        Assert.ok(erc20.approve(acc0, 10000), "Approve to acc0 10000 BT");
        Assert.equal(erc20.allowance(address(this), acc0), 10000, "The allowance acc0 received by address(this) is 10000 BT.");
        
        Assert.ok(erc20.updateOwner(acc0), "Update the owner to acc0.");
        Assert.ok(erc20.getOwner() == acc0, "Current Owner is acc0");

        Assert.ok(erc20.transferFrom(address(this), acc0, 10000), "Transfer from address(this) to acc0.");
        Assert.ok(erc20.allowance(address(this), acc0) == 0, "The allowance acc0 received by address(this) is 0 BT.");
        
        Assert.ok(erc20.balanceOf(address(this)) == 990000, "The balance of address(this) is 990000 BT.");
        Assert.ok(erc20.balanceOf(acc0) == 10000, "The balance of acc0 is 10000 BT.");
    }
}
}