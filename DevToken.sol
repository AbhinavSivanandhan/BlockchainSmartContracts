// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

// Import OpenZeppelin's ERC20 implementation
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Contract definition, inheriting from ERC20
contract NYUDEV is ERC20 {
    // Address of the contract owner
    address public owner;

    // Modifier: Ensures that a function can only be called by the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    // Contract constructor, initializes ERC20 with name "NYUDEV" and symbol "NYUD"
    constructor() ERC20("NYUDEV", "NYUD") {
        // Mint 1000 NYUDEV tokens to the contract deployer (msg.sender)
        _mint(msg.sender, 1000 * 10**18);
        
        // Set the contract deployer as the owner
        owner = msg.sender;
    }

    // Function: Allows the owner to mint new tokens and send them to a specified account
    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }

    // Function: Allows any account to burn a specified amount of their own tokens
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    // Function: Overrides ERC20 transfer to add additional validation
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(recipient != address(0), "ERC20: transfer to the zero address");
        return super.transfer(recipient, amount);
    }

    // Function: Overrides ERC20 transferFrom to add additional validation
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(recipient != address(0), "ERC20: transfer to the zero address");
        return super.transferFrom(sender, recipient, amount);
    }

    // Function: Overrides ERC20 approve to use the OpenZeppelin implementation
    function approve(address spender, uint256 amount) public override returns (bool) {
        return super.approve(spender, amount);
    }
}
