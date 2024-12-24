// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RECYC is ERC20, Ownable {
    uint256 public constant MAX_SUPPLY = 1000000000000 * (10 ** 18); // 1 trillion tokens
    uint256 public burnRate = 2; // 2% of each transaction is burned
    address public feeCollector; // Address for collecting fees

    constructor(address _feeCollector) ERC20("RECYC Coin", "RECYC") {
        require(_feeCollector != address(0), "Fee collector address cannot be zero");
        feeCollector = _feeCollector;

        // Initial mint: 100 million tokens
        _mint(msg.sender, 100000000 * (10 ** 18));
    }

    // Set the address for fee collection
    function setFeeCollector(address _feeCollector) external onlyOwner {
        require(_feeCollector != address(0), "Fee collector address cannot be zero");
        feeCollector = _feeCollector;
    }

    // Set the burn rate percentage
    function setBurnRate(uint256 _burnRate) external onlyOwner {
        require(_burnRate <= 10, "Burn rate cannot exceed 10%");
        burnRate = _burnRate;
    }

    // Overriding the transfer function with added burn and fee logic
    function _transfer(address sender, address recipient, uint256 amount) internal override {
        uint256 burnAmount = (amount * burnRate) / 100; // Calculate how many tokens to burn
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

    // Mint new tokens (up to the max supply limit)
    function mint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Max supply exceeded");
        _mint(to, amount);
    }

    // Burn tokens (for deflationary purpose)
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}
