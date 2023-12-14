// SPDX-License-Identifier: UNLICENSED
// ALL RIGHTS RESERVED

pragma solidity 0.8.20;

import "../libraries/Ownable.sol";

contract FeeHelper is Ownable{
    
    struct Settings {
        uint256 FEE; 
        uint256 DENOMINATOR;
        address payable FEE_ADDRESS;
    }
    
    Settings public SETTINGS;
    
    constructor() Ownable(msg.sender) {
        SETTINGS.FEE = 100;
        SETTINGS.DENOMINATOR = 10000;
        SETTINGS.FEE_ADDRESS = payable(msg.sender);
    }

    function getFeeAmount(uint256 _amount) external view returns(uint256) {
        return _amount * SETTINGS.FEE / SETTINGS.DENOMINATOR;
    }
    
    function getFee() external view returns(uint256) {
        return SETTINGS.FEE;
    }

    function getFeeDenominator() external view returns(uint256) {
        return SETTINGS.DENOMINATOR;
    }
    
    function setFee(uint _fee) external onlyOwner {
        SETTINGS.FEE = _fee;
    }
    
    function getFeeAddress() external view returns(address) {
        return SETTINGS.FEE_ADDRESS;
    }
    
    function setFeeAddress(address payable _feeAddress) external onlyOwner {
        SETTINGS.FEE_ADDRESS = _feeAddress;
    }
} 