
pragma solidity ^0.8.0;

import "./libraries/Ownable.sol";

contract Wallet is Owanable {

    constructor() Ownable(msg.sender)){
    }

    function deposit() public payable {
        // Deposit funds into the wallet
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance");
        payable(owner).transfer(amount);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
