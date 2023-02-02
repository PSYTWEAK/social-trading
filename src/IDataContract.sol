// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

interface IDataContract {
    function isExchangeAllowed(address exchange) external view returns (bool);
}