// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CoreProxy {
    address private _implementation;
    address private _admin;

    event Upgraded(address indexed implementation);

    constructor(address initialImplementation, address admin) {
        _implementation = initialImplementation;
        _admin = msg.sender;
    }

    function implementation() public view returns (address) {
        return _implementation;
    }

    function admin() public view returns (address) {
        return _admin;
    }

    function upgradeTo(address newImplementation) public {
        require(msg.sender == _admin, "Only admin can upgrade");
        require(newImplementation != address(0), "Invalid implementation address");

        _implementation = newImplementation;

        emit Upgraded(newImplementation);
    }

    fallback() external payable {
        address _impl = _implementation;
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)

            switch result
            case 0 {
                revert(ptr, size)
            }
            default {
                return(ptr, size)
            }
        }
    }
}
