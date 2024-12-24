// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RecycToken is ERC20, Ownable {
    uint256 public maxSupply = 1000000000000 * (10 ** uint256(decimals()));
    uint256 public reserveSupply = 50000000000 * (10 ** uint256(decimals()));
    uint256 public transactionFeePercentage = 0;

    address public liquidityPool;

    mapping(address => bool) public distributors;

    constructor() ERC20("Recyc", "RECYC") {
        _mint(msg.sender, maxSupply - reserveSupply);
        liquidityPool = msg.sender;
    }

    modifier onlyDistributor() {
        require(distributors[msg.sender], "Not a distributor");
        _;
    }

    function setTransactionFee(uint256 _feePercentage) external onlyOwner {
        require(_feePercentage >= 0.5 && _feePercentage <= 5, "Fee must be between 0.5% and 5%");
        transactionFeePercentage = _feePercentage;
    }

    function addDistributor(address distributor) external onlyOwner {
        distributors[distributor] = true;
    }

    function removeDistributor(address distributor) external onlyOwner {
        distributors[distributor] = false;
    }

    function distribute(address to, uint256 amount) external onlyDistributor {
        uint256 fee = (amount * transactionFeePercentage) / 100;
        uint256 amountAfterFee = amount - fee;

        _transfer(owner(), to, amountAfterFee);
        _transfer(owner(), liquidityPool, fee);
    }

    function burn(uint256 amount) external onlyOwner {
        _burn(msg.sender, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        super._beforeTokenTransfer(from, to, amount);
        require(totalSupply() + amount <= maxSupply, "Max supply exceeded");
    }
}

