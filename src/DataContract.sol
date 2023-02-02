// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

contract Account {
    mapping(address => bool) public allowedExchange;

    function toggleExchange(address exchange) public {
        allowedExchange[exchange] = !allowedExchange[exchange];
    }


 }
