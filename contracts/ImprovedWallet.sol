// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.26;

struct AddressWallet {
    uint balance;
    
    uint allowedSpenderNumber;
    mapping(address => bool) allowedSpenders;
    
    uint allowedWithdrawerNumber;
    mapping(address => bool) allowedWithdrawers;
}

contract Wallets {
    mapping(address => AddressWallet) public wallets;

    receive() external payable {
        wallets[msg.sender].balance += msg.value;
    }

    modifier onlyOwnerOrAllowedSpender(address from) {
        require(
            from == msg.sender || 
            wallets[from].allowedSpenders[msg.sender],
            "Not allowed to send transaction from this address"
        );
        _;
    }

    modifier onlyOwnerOrAllowedWithdrawer(address from) {
        require(
            from == msg.sender || 
            wallets[from].allowedWithdrawers[msg.sender],
            "Not allowed to withdraw transaction from this address"
        );
        _;
    }

    modifier sufficientFunds(address from, uint amount) {
        require( 
            wallets[from].balance >= amount,
            "InsufficientFunds"
        );
        _;
    }

    function sendTransaction(address from, address to, uint amount) public onlyOwnerOrAllowedSpender(from) sufficientFunds(from, amount) {
        wallets[from].balance -= amount;
        (bool success, ) = to.call{value: amount, gas: 100000}("");
        require(success, "Error when trying to call this address");
    }

    function withdraw(address from, uint amount) public onlyOwnerOrAllowedWithdrawer(from) sufficientFunds(from, amount) {
        wallets[from].balance -= amount;
        payable(msg.sender).transfer(amount);
    }

    function giveRightToSpend(address spender) public {
        require(msg.sender != spender, "Owner already has right to spend");
        wallets[msg.sender].allowedSpenderNumber++;
        wallets[msg.sender].allowedSpenders[spender] = true;
    }

    function revokeRightToSpend(address spender) public {
        require(msg.sender != spender, "You cannot revoke owner");
        wallets[msg.sender].allowedSpenderNumber--;
        wallets[msg.sender].allowedSpenders[spender] = false;
    }

    function giveRightToWithdraw(address withdrawer) public {
        require(msg.sender != withdrawer, "Owner already has right to withdraw");
        require(wallets[msg.sender].allowedWithdrawerNumber < 5, "Cannot set more than 5 wallet withdrawers");
        wallets[msg.sender].allowedWithdrawerNumber++;
        wallets[msg.sender].allowedWithdrawers[withdrawer] = true;
    }

    function revokeRightToWithdraw(address withdrawer) public {
        require(msg.sender != withdrawer, "You cannot revoke owner");
        wallets[msg.sender].allowedWithdrawerNumber--;
        wallets[msg.sender].allowedWithdrawers[withdrawer] = false;
    }
}