// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RecycToken is ERC20, Ownable {

    uint256 public maxSupply = 1000000000000 * (10 ** uint256(decimals())); // Maximum token supply
    uint256 public reserveSupply = 50000000000 * (10 ** uint256(decimals())); // Reserved supply (for liquidity, staking, etc.)
    uint256 public transactionFeePercentage = 0; // Initial transaction fee is set to 0%

    address public liquidityPool; // Liquidity pool address

    mapping(address => bool) public distributors; // A list of approved distributors

    constructor() ERC20("Recyc", "RECYC") {
        _mint(msg.sender, maxSupply - reserveSupply); // Mint the initial supply, excluding the reserved tokens
        liquidityPool = msg.sender; // Set the contract owner as the liquidity pool owner
    }

    // Modifier to allow only distributors to call certain functions
    modifier onlyDistributor() {
        require(distributors[msg.sender], "Not a distributor");
        _;
    }

    // Function to set the transaction fee percentage (0.5% to 5%)
    function setTransactionFee(uint256 _feePercentage) external onlyOwner {
        require(_feePercentage >= 0.5 && _feePercentage <= 5, "Fee must be between 0.5% and 5%");
        transactionFeePercentage = _feePercentage; // Set the transaction fee
    }

    // Allow adding a distributor (address allowed to distribute tokens)
    function addDistributor(address distributor) external onlyOwner {
        distributors[distributor] = true;
    }

    // Allow removing a distributor
    function removeDistributor(address distributor) external onlyOwner {
        distributors[distributor] = false;
    }

    // Function to distribute tokens with the transaction fee
    function distribute(address to, uint256 amount) external onlyDistributor {
        uint256 fee = (amount * transactionFeePercentage) / 100; // Calculate the fee
        uint256 amountAfterFee = amount - fee; // Calculate the amount after fee deduction

        // Transfer tokens to the recipient, excluding the fee
        _transfer(owner(), to, amountAfterFee);
        // Transfer the fee to the liquidity pool
        _transfer(owner(), liquidityPool, fee);
    }

    // Check total supply before transferring tokens (to respect the max supply limit)
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        super._beforeTokenTransfer(from, to, amount);
        require(totalSupply() + amount <= maxSupply, "Max supply exceeded"); // Ensure max supply limit is not exceeded
    }
}
