// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RECYC is ERC20, Ownable {
    uint256 public constant MAX_SUPPLY = 1000000000000 * (10 ** 18); // 1 trillion tokens
    uint256 public burnRate = 2; // 2% of each transaction will be burned
    address public feeCollector; // Address for collecting fees

    uint256 public distributionRate = 5; // 5% to be distributed initially
    uint256 public totalDistributed = 0; // Total amount of tokens distributed

    constructor(address _feeCollector) ERC20("RECYC Coin", "RECYC") {
        require(_feeCollector != address(0), "Fee collector address cannot be zero");
        feeCollector = _feeCollector;

        // Initial mint: 100 million tokens
        uint256 initialSupply = 100000000 * (10 ** 18); 
        _mint(msg.sender, initialSupply); // Mint tokens to the owner's address

        // Distribute 5% of the initial supply
        uint256 distributionAmount = (initialSupply * distributionRate) / 100;
        _mint(address(this), distributionAmount); // Mint 5% to the contract for distribution
        totalDistributed += distributionAmount;
    }

    // Function to change the fee collector address
    function setFeeCollector(address _feeCollector) external onlyOwner {
        require(_feeCollector != address(0), "Fee collector address cannot be zero");
        feeCollector = _feeCollector;
    }

    // Function to change the burn rate
    function setBurnRate(uint256 _burnRate) external onlyOwner {
        require(_burnRate <= 10, "Burn rate cannot exceed 10%");
        burnRate = _burnRate;
    }

    // Overriding the transfer function to include burn and fee collection logic
    function _transfer(address sender, address recipient, uint256 amount) internal override {
        uint256 burnAmount = (amount * burnRate) / 100; // Calculate the burn amount
        uint256 feeAmount = (amount * burnRate) / 100;  // Calculate the fee amount

        uint256 sendAmount = amount - burnAmount - feeAmount; // Remaining amount to send
        require(sendAmount > 0, "Transfer amount too small");

        // Burning tokens
        _burn(sender, burnAmount);

        // Sending fee to the fee collector
        super._transfer(sender, feeCollector, feeAmount);

        // Sending the remaining tokens to the recipient
        super._transfer(sender, recipient, sendAmount);
    }

    // Function to distribute tokens to multiple recipients
    function distributeTokens(address[] calldata recipients, uint256 amountPerRecipient) external onlyOwner {
        uint256 totalAmount = recipients.length * amountPerRecipient;
        require(totalDistributed + totalAmount <= (MAX_SUPPLY * 30) / 100, "Exceeds total distribution limit");

        // Distribute tokens to recipients
        for (uint256 i = 0; i < recipients.length; i++) {
            _transfer(address(this), recipients[i], amountPerRecipient);
        }
        totalDistributed += totalAmount; // Update the total distributed amount
    }

    // Function to mint new tokens (up to the max supply)
    function mint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Max supply exceeded");
        _mint(to, amount);
    }

    // Function to burn tokens (for deflationary purpose)
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}
