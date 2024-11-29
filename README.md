# Wallet Smart Contract

## Features

- __Deposit Funds__: Users can send Ether to their wallet using the receive() function.
- __Send Transactions__: Wallet owners or allowed spenders can transfer Ether from the wallet to another address.
- __Withdraw Funds__: Wallet owners or allowed withdrawers can withdraw Ether from the wallet to their own address.
- __Delegate Permissions__: Wallet owners can grant or revoke permissions to others for spending and withdrawing funds on their behalf.

## Contract Details

##### AddressWallet

```solidity
struct AddressWallet {
    uint balance;
    uint allowedSpenderNumber;
    mapping(address => bool) allowedSpenders;
    uint allowedWithdrawerNumber;
    mapping(address => bool) allowedWithdrawers;
}
```

- __balance__ (uint): The balance of Ether stored in the wallet.
- __allowedSpenderNumber__ (uint): The number of addresses that are allowed to spend from this wallet.
- __allowedSpenders__ (mapping): A mapping that tracks addresses that have spending permission.
- __allowedWithdrawerNumber__ (uint): The number of addresses that are allowed to withdraw from this wallet.
- __allowedWithdrawers__ (mapping): A mapping that tracks addresses that have withdrawal permission.

##### Wallets

```solidity
mapping(address => AddressWallet) public wallets;
```

This mapping stores the wallet data for each address. Each address has a corresponding AddressWallet struct that tracks the balance, allowed spenders, and allowed withdrawers.
