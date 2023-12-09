// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Escrow {
    // Addresses of parties involved
    address public alice;
    address public bob = 0xECf74C19215C8DD2BAF16AD3a6eC1A25386d813c; // Bob's address is hardcoded
    
    // Deposit and release parameters
    uint256 public depositAmount;
    uint256 public releaseTime = block.timestamp + 1 days; // Release time is hardcoded to 1 day
    
    bool public fundsReleased;

    event Deposit(address indexed depositor, uint256 amount);
    event Withdrawal(address indexed withdrawer, uint256 amount);

    // Contract deployment initializes Alice's address
    constructor() {
        alice = msg.sender;
    }

    // Modifier: Ensures that a function can only be called by Alice
    modifier onlyAlice() {
        require(msg.sender == alice, "Only Alice can call this function");
        _;
    }

    // Modifier: Ensures that a function can only be called by Bob
    modifier onlyBob() {
        require(msg.sender == bob, "Only Bob can call this function");
        _;
    }

    // Modifier: Ensures that funds have not already been released
    modifier fundsNotReleased() {
        require(!fundsReleased, "Funds have already been released");
        _;
    }

    // Modifier: Ensures that funds can be released based on the specified time
    modifier releaseFunds() {
        require(block.timestamp >= releaseTime, "Funds cannot be released yet");
        _;
    }

    // Function: Allows Alice to deposit funds into the escrow
    function deposit(uint256 amount) external payable onlyAlice fundsNotReleased {
        require(amount > 0, "Deposit amount must be more than ZERO");
        require(depositAmount == 0, "Contract currently in Effect");
        depositAmount = amount;
        emit Deposit(msg.sender, depositAmount);
    }

    // Function: Allows Bob to withdraw funds after the specified release time
    function withdraw() external onlyBob releaseFunds fundsNotReleased {
        fundsReleased = true;
        payable(bob).transfer(address(this).balance);
        emit Withdrawal(msg.sender, depositAmount);
    }

    // Function: Retrieves the current balance of the escrow (funds not released)
    function getDepositAmount() view external fundsNotReleased returns (uint256){
        return address(this).balance * 1;
    }
}
