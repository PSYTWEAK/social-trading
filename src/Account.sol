// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import {IDataContract} from "./IDataContract.sol";
import {Investors} from "./Investors.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Account is Investors {

    address public manager;
    address public dataContract;

    Trade public currentTrade;

    struct Trade {
        bool active; 
        uint usdcIn;
        uint tradeCount;
    }

    constructor(address _manager, address _dataContract) {
        manager = _manager;
        dataContract = _dataContract;
    }

    // =================== Modifiers ===================

    modifier onlyManager() {
        require(msg.sender == manager, "Account: Only manager can call this function.");
        _;
    }

    // =================== Other ===================

    fallback() external payable {
        revert("Account: fallback function not allowed");
    }

 }
