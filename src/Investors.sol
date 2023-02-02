// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

    error TradeActive();
    error TradeInActive();
    error BalanceNotEnough();

contract Investors {

    Shares public shares;

    struct Shares {
        uint total;
        mapping(address => uint) balances;
        uint price;
        uint totalPendingWithdrawals;
        mapping(address => mapping(uint => uint)) pendingWithdrawals;
    }
    
    // =================== External Functions ===================

    function deposit(uint usdcAmt) external payable {
        if (this.currentTrade.active) revert TradeActive(); 

        uint balanceBefore = IERC20(USDC).balanceOf(address(this));

        IERC20(USDC).transferFrom(msg.sender, address(this), amount);

        uint balanceAfter = IERC20(USDC).balanceOf(address(this));

        uint usdcIn = balanceAfter - balanceBefore;
        uint shares = _calculateAmountOfShares(usdcIn);

        shares.total += shares;
        shares.balances[msg.sender] += shares;
    }

    function setPendingWithdrawal(uint amount) external {
        if (!this.currentTrade.active) revert TradeInActive();
        if (shares.balances[msg.sender] < amount) revert BalanceNotEnough();

        shares.balances[msg.sender] -= amount;

        uint tradeCount = this.currentTrade.tradeCount;

        shares.pendingWithdrawals[msg.sender][tradeCount] += amount;
        shares.totalPendingWithdrawals += amount;
    }

    function withdrawPending(uint tradeCount) external {
        if (tradeCount == this.currentTrade.tradeCount) revert TradeActive();

        uint shareAmount = shares.pendingWithdrawals[msg.sender][tradeCount];

        shares.pendingWithdrawals[msg.sender][tradeCount] = 0;
        shares.totalPendingWithdrawals -= shareAmount;
        shares.total -= shareAmount;

        uint usdcOut = _calculateShareUSDValue(shareAmount);

        IERC20(USDC).transfer(msg.sender, shareAmount);
    }

    function withdraw() external {
        if (this.currentTrade.active) revert TradeActive(); 

        uint shares = shares.balances[msg.sender];

        uint usdcOut = _calculateShareUSDValue(shares);

        shares.total -= shares;
        shares.balances[msg.sender] -= shares;

        shares.pendingWithdrawals += usdcOut;
    }

    // =================== Internal Functions ===================

    function _calculateAmountOfShares(uint usdcAmt) internal view returns (uint) {
        return (usdcAmt * 1e18) / shares.price;
    }

    function _calculateShareUSDValue(uint shares) internal view returns (uint) {
        return (shares * shares.price) / 1e18;
    }
 }
