// SPDX-License-Identifier: UNLICENSED
// ALL RIGHTS RESERVED

pragma solidity 0.8.20;

interface IFeeHelper {

    function getFeeAmount(uint256 _amount) external view returns(uint256);

    function getFee() view external returns(uint256);
    
    function getFeeDenominator() view external returns(uint256);
    
    function setFee(uint _fee) external;
    
    function getFeeAddress() view external returns(address);
    
    function setFeeAddress(address payable _feeAddress) external;
}