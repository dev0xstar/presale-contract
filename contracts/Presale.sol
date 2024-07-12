// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Presale is Ownable {
    IERC20 public token1;
    IERC20 public token;
    uint256 public start;
    uint256 public minFund = 50 * 1 ether;
    uint256 public sum;

    uint256 public period = 40 minutes;
    
    uint256 public tokenprice = 10;
    mapping(address => uint256) public balances;
    mapping(address => uint256) public balancetoken;

    event Deposit(address indexed depositor, uint256 amount);
    event Withdrawal(address indexed depositor, uint256 amount);

    constructor(IERC20 _token) {
        // require(start < end, "Start must be before end");
        token = _token;
        start = block.timestamp;
    }

    function setPeriod(uint256 _period) external onlyOwner {
        
        period = _period;

    }

    function deposit(uint256 numberOfTokens) external {

        require(block.timestamp >= start && block.timestamp <= start + period, "Presale not active");
        uint256 amount = token.balanceOf(msg.sender);
        require(amount > 0, "No tokens to deposit");
        require(amount >= numberOfTokens * tokenprice, "Insufficient balance");
        // require(token.allowance(msg.sender, address(this)) >= numberOfTokens * tokenprice, "Allowance not set for this");

        balances[msg.sender] += numberOfTokens * tokenprice;
        balancetoken[msg.sender] += numberOfTokens;
        // token.approve(address(this), numberOfTokens * tokenprice);
        token.transferFrom(msg.sender, address(this), numberOfTokens * tokenprice);
        
        sum += numberOfTokens * tokenprice;
        

        emit Deposit(msg.sender, numberOfTokens);
    }

    function setRefundToken(IERC20 _token1) external onlyOwner {
        token1 = _token1;
    }

    function refund() external {
        require(block.timestamp > start + period, "Presale not active");
        uint256 balance;
        if (minFund > sum) {        // failed in presale
            // transfer(msg.sender, balances[msg.sender]);
            balance = balances[msg.sender];
            require(balance > 0, "no ballance to refund");
            balances[msg.sender] = 0;
            // transfer(msg.sender, balance);
            token.transfer(msg.sender, balance);

        } else {    // success in presale
            // transfer(msg.sender, balancetoken[msg.sender]);
            balance = balancetoken[msg.sender];
            require(balance > 0, "no tokens to refund");
            balancetoken[msg.sender] = 0;
            token1.transfer(msg.sender, balance);
        }
    }
}

// 0xd346Cb76ba8407da118aEc4f553acDD6BCAE2543