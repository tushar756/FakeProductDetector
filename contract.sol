// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract FakeProductDetector {
    struct Product {
        bytes32 productId;
        string productName;
        uint256 productPrice;
        bool isFake;
        address registeredBy;
    }

    mapping(bytes32 => Product) public productList;
    event ProductRegistered(bytes32 indexed productId, string productName, uint256 productPrice, address indexed registeredBy);
    event ProductReportedFake(bytes32 indexed productId, address indexed reporter);

    function registerProduct(bytes32 productId, string memory name, uint256 price) public {
        require(productList[productId].productId == 0, "Product already exists");

        productList[productId] = Product({
            productId: productId,
            productName: name,
            productPrice: price,
            isFake: false,
            registeredBy: msg.sender
        });

        emit ProductRegistered(productId, name, price, msg.sender);
    }

    function reportFakeProduct(bytes32 productId) public {
        require(productList[productId].productId != 0, "Product not found");
        require(!productList[productId].isFake, "Product is already marked as fake");

        productList[productId].isFake = true;
        emit ProductReportedFake(productId, msg.sender);
    }

    function isFakeProduct(bytes32 productId) public view returns (bool) {
        require(productList[productId].productId != 0, "Product not found");
        return productList[productId].isFake;
    }

    function getProductDetails(bytes32 productId) public view returns (string memory, uint256, bool, address) {
        require(productList[productId].productId != 0, "Product not found");
        Product memory product = productList[productId];
        return (product.productName, product.productPrice, product.isFake, product.registeredBy);
    }
}
