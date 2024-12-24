// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RecycToken is ERC20, Ownable {

    uint256 public maxSupply = 1000000000000 * (10 ** uint256(decimals()));
    uint256 public reserveSupply = 50000000000 * (10 ** uint256(decimals()));
    uint256 public transactionFeePercentage = 0; // Начальная комиссия 0%

    address public liquidityPool; // Адрес пула ликвидности

    mapping(address => bool) public distributors;

    constructor() ERC20("Recyc", "RECYC") {
        _mint(msg.sender, maxSupply - reserveSupply); // Mint initial supply excluding reserve
        liquidityPool = msg.sender; // Установим владельца пула ликвидности как владельца контракта
    }

    // Modifier to allow only distributors to call certain functions
    modifier onlyDistributor() {
        require(distributors[msg.sender], "Not a distributor");
        _;
    }

    // Функция для установки нового процента комиссии от 0.5% до 5%
    function setTransactionFee(uint256 _feePercentage) external onlyOwner {
        require(_feePercentage >= 0.5 && _feePercentage <= 5, "Fee must be between 0.5% and 5%");
        transactionFeePercentage = _feePercentage;
    }

    // Allow adding distributors (addresses that can distribute tokens)
    function addDistributor(address distributor) external onlyOwner {
        distributors[distributor] = true;
    }

    // Allow removing distributors
    function removeDistributor(address distributor) external onlyOwner {
        distributors[distributor] = false;
    }

    // Функция для распределения токенов (с комиссией)
    function distribute(address to, uint256 amount) external onlyDistributor {
        uint256 fee = (amount * transactionFeePercentage) / 100;
        uint256 amountAfterFee = amount - fee;

        // Переводим токены с учетом комиссии
        _transfer(owner(), to, amountAfterFee);
        _transfer(owner(), liquidityPool, fee); // Комиссия идет на пул ликвидности
    }

    // Функция для сжигания токенов
    function burn(uint256 amount) external onlyOwner {
        _burn(msg.sender, amount);
    }

    // Функция для проверки общего предложения, с учетом лимита
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        super._beforeTokenTransfer(from, to, amount);
        require(totalSupply() + amount <= maxSupply, "Max supply exceeded");
    }
}
