
pragma solidity 0.8.20;

import "../libraries/Ownable.sol";

contract Wallet is Ownable {

    constructor() Ownable(msg.sender){
    }

    function deposit() public payable {
        // Deposit funds into the wallet
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance");
        payable(owner()).transfer(amount);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
