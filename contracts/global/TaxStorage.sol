
pragma solidity 0.8.20;

contract TaxStorage {
    struct TaxSettings {
        CustomTax[] customTaxes;
    }

    struct CustomTax {
        string name;
        Fee fee;
        address wallet;
        bool isBase;
    }

    struct Fee {
        uint256 base;
        uint256 buy;
        uint256 sell;
    }
}


