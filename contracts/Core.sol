
pragma solidity ^0.8.0;

import "./libraries/Ownable.sol";

contract Core is Ownable {
    struct Addresses {
        address taxHelper;
        address feeHelper;
        address revShare;
    }

    Addresses public addresses;

    constructor() {
        _owner = msg.sender;
    }

    // Setters and Getters

    function setTaxHelperAddress(address _taxHelper) public onlyOwner {
        addresses.taxHelper = _taxHelper;
    }

    function getTaxHelperAddress() public returns (address) {
        return addresses.taxHelper;
    }

    function setFeeHelperAddress(address _feeHelper) public onlyOwner {
        addresses.feeHelper = _feeHelper;
    }

    function getFeeHelperAddress() public returns (address) {
        return addresses.feeHelper;
    }

    function setRevShareAddress(address _revShare) public onlyOwner {
        addresses.revShare = _revShare;
    }

    function getRevShareAddress() public returns (address) {
        return addresses.revShare;
    }

}
