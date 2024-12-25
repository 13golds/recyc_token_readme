// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract RecycToken is ERC20, Ownable, ReentrancyGuard {

    uint256 public constant MAX_SUPPLY = 1000000000000 * 10**18; // Maximum token supply
    uint256 public constant RESERVED_SUPPLY = 50000000000 * 10**18; // Reserved supply
    uint256 public transactionFeePercentage = 5; // Transaction fee (in basis points, 5 = 0.5%)

    address public liquidityPool; // Liquidity pool address

    mapping(address => bool) public distributors; // A list of approved distributors

    constructor() ERC20("Recyc", "RECYC") {
        _mint(msg.sender, MAX_SUPPLY - RESERVED_SUPPLY); // Mint the initial supply
        liquidityPool = msg.sender; // Set owner as the initial liquidity pool
    }

    // Modifier to allow only distributors to call certain functions
    modifier onlyDistributor() {
        require(distributors[msg.sender], "Not a distributor");
        _;
    }

    // Function to set the transaction fee (0.5% to 5%)
    function setTransactionFee(uint256 _feePercentage) external onlyOwner {
        require(_feePercentage >= 5 && _feePercentage <= 500, "Fee must be between 0.5% and 5%");
        transactionFeePercentage = _feePercentage; // Set the transaction fee
        emit TransactionFeeUpdated(_feePercentage);
    }

    // Add a distributor
    function addDistributor(address distributor) external onlyOwner {
        distributors[distributor] = true;
        emit DistributorAdded(distributor);
    }

    // Remove a distributor
    function removeDistributor(address distributor) external onlyOwner {
        distributors[distributor] = false;
        emit DistributorRemoved(distributor);
    }

    // Distribute tokens with fee deduction
    function distribute(address to, uint256 amount) external onlyDistributor nonReentrant {
        uint256 fee = (amount * transactionFeePercentage) / 1000; // Calculate fee
        uint256 amountAfterFee = amount - fee; // Amount after fee

        _transfer(owner(), to, amountAfterFee); // Transfer to recipient
        _transfer(owner(), liquidityPool, fee); // Transfer fee to liquidity pool

        emit TokensDistributed(to, amountAfterFee, fee);
    }

    // Burn tokens
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
        emit TokensBurned(msg.sender, amount);
    }

    // Events
    event TransactionFeeUpdated(uint256 newFee);
    event DistributorAdded(address indexed distributor);
    event DistributorRemoved(address indexed distributor);
    event TokensDistributed(address indexed to, uint256 amountAfterFee, uint256 fee);
    event TokensBurned(address indexed burner, uint256 amount);
}
