// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Escrow {
    address public alice;
    address public bob = 0xECf74C19215C8DD2BAF16AD3a6eC1A25386d813c; // Bob's address is hardcoded
    uint256 public depositAmount;
    uint256 public releaseTime = block.timestamp + 1 days; // Release time is hardcoded to 1 day
    bool public fundsReleased;

    event Deposit(address indexed depositor, uint256 amount);
    event Withdrawal(address indexed withdrawer, uint256 amount);

    constructor() {
        alice = msg.sender;
    }

    modifier onlyAlice() {
        require(msg.sender == alice, "Only Alice can call this function");
        _;
    }

    modifier onlyBob() {
        require(msg.sender == bob, "Only Bob can call this function");
        _;
    }

    modifier fundsNotReleased() {
        require(!fundsReleased, "Funds have already been released");
        _;
    }

    modifier releaseFunds() {
        require(block.timestamp >= releaseTime, "Funds cannot be released yet");
        _;
    }

    function deposit(uint256 amount) external payable onlyAlice fundsNotReleased {
        require(amount > 0, "deposit amount must be more than ZERO");
        require(depositAmount == 0, "Contract currently in Effect");
        depositAmount = amount;
        emit Deposit(msg.sender, depositAmount);
    }

    function withdraw() external onlyBob releaseFunds fundsNotReleased {
        fundsReleased = true;
        payable(bob).transfer(address(this).balance);
        emit Withdrawal(msg.sender, depositAmount);
    }

    function getDepositAmount() view external fundsNotReleased returns (uint256){
        return address(this).balance * 1;
    }
}