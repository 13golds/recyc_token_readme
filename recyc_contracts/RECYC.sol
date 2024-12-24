// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RECYC is ERC20, Ownable {
    uint256 public constant MAX_SUPPLY = 1000000000000 * (10 ** 18); // 1 trillion tokens
    uint256 public burnRate = 2; // 2% of each transaction is burned
    uint256 public constant INITIAL_DISTRIBUTION = MAX_SUPPLY * 5 / 100; // 5% for initial click distribution (50 billion tokens)
    uint256 public constant NEXT_PHASE_DISTRIBUTION = MAX_SUPPLY * 5 / 100; // 5% for subsequent clicks (50 billion tokens)

    uint256 public constant CLICK_LIMIT_TIME = 3 hours; // 3 hours for each click
    uint256 public constant MAX_CONCURRENT_USERS = 1000; // Max concurrent users who can click at once

    mapping(address => uint256) public lastClickTime; // Track the last click time for each user
    uint256 public totalDistributed = 0; // Track total distributed tokens
    address public feeCollector; // Address for collecting fees
    address public creatorAddress; // Address of the creator for future distribution

    constructor(address _feeCollector, address _creatorAddress) ERC20("RECYC Coin", "RECYC") {
        require(_feeCollector != address(0), "Fee collector address cannot be zero");
        require(_creatorAddress != address(0), "Creator address cannot be zero");

        feeCollector = _feeCollector;
        creatorAddress = _creatorAddress;

        // Mint 5% for initial click distribution
        _mint(address(this), INITIAL_DISTRIBUTION); // Mint to contract itself for distribution
        
        // Mint 5% for future clicks distribution
        _mint(address(this), NEXT_PHASE_DISTRIBUTION);
        
        // Mint 40% for partners distribution
        _mint(address(this), MAX_SUPPLY * 40 / 100);

        // Mint 30% for system development (recycling plants)
        _mint(address(this), MAX_SUPPLY * 30 / 100);

        // Mint 20% for creator and further development
        _mint(creatorAddress, MAX_SUPPLY * 20 / 100);
    }

    // Set the address for fee collection
    function setFeeCollector(address _feeCollector) external onlyOwner {
        require(_feeCollector != address(0), "Fee collector address cannot be zero");
        feeCollector = _feeCollector;
    }

    // Set the creator address for future distributions
    function setCreatorAddress(address _creatorAddress) external onlyOwner {
        require(_creatorAddress != address(0), "Creator address cannot be zero");
        creatorAddress = _creatorAddress;
    }

    // Set the burn rate percentage
    function setBurnRate(uint256 _burnRate) external onlyOwner {
        require(_burnRate <= 10, "Burn rate cannot exceed 10%");
        burnRate = _burnRate;
    }

    // Function for distributing tokens for clicks (limited to 1000 users at once)
    function distributeTokens(address[] memory recipients, uint256 amount) external onlyOwner {
        require(recipients.length <= MAX_CONCURRENT_USERS, "Cannot distribute to more than 1000 users at once");

        uint256 totalAmount = recipients.length * amount;
        require(totalDistributed + totalAmount <= INITIAL_DISTRIBUTION + NEXT_PHASE_DISTRIBUTION, "Total distribution limit exceeded");

        for (uint i = 0; i < recipients.length; i++) {
            require(recipients[i] != address(0), "Recipient address cannot be zero");

            // Ensure that 3 hours have passed since the last click
            require(block.timestamp >= lastClickTime[recipients[i]] + CLICK_LIMIT_TIME, "You can click only once every 3 hours");

            // Update the last click time
            lastClickTime[recipients[i]] = block.timestamp;

            // Distribute the token to the user
            _transfer(address(this), recipients[i], amount);
        }

        totalDistributed += totalAmount;
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
