// this contract is used to create new accounts.sol

pragma solidity ^0.8.13;

import {Account} from "./Account.sol";

contract AccountFactory {

    address public _dataContract;

    function createAccount() public returns (address newAccount) {
        newAccount = address(new Account(msg.sender, _dataContract));
    }
}