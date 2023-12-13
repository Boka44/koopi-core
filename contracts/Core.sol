
pragma solidity ^0.8.0;

import "./libraries/Ownable.sol";

contract Core is Ownable {
    struct Addresses {
        address taxHelper;
        address revShare;

    }

    Addresses public addresses;

    constructor() {
        _owner = msg.sender;
    }

    // Setters and Getters
    
    setTaxHelperAddress(address _taxHelper) public onlyOwner {
        addresses.taxHelper = _taxHelper;
    }

    getTaxHelperAddress() public returns (address) {
        return addresses.taxHelper;
    }

    setRevShareAddress(address _revShare) public onlyOwner {
        addresses.revShare = _revShare;
    }

    getRevShareAddress() public returns (address) {
        return addresses.revShare;
    }

}
