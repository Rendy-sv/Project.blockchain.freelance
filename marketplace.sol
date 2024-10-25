// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Marketplace {
    IERC20 public token;

    struct Listing {
        address seller;
        uint256 price;
        uint256 amount;
    }

    mapping(uint256 => Listing) public listings;
    uint256 public listingCount;

    event Listed(uint256 indexed listingId, address indexed seller, uint256 price, uint256 amount);
    event Purchased(uint256 indexed listingId, address indexed buyer, uint256 amount);

    constructor(IERC20 _token) {
        token = _token;
    }

    function listToken(uint256 price, uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        token.transferFrom(msg.sender, address(this), amount);

        listingCount++;
        listings[listingCount] = Listing(msg.sender, price, amount);

        emit Listed(listingCount, msg.sender, price, amount);
    }

    function purchaseToken(uint256 listingId, uint256 amount) external payable {
        Listing storage listing = listings[listingId];
        require(msg.value == listing.price * amount, "Incorrect price");
        require(listing.amount >= amount, "Not enough tokens in listing");

        listing.amount -= amount;
        token.transfer(msg.sender, amount);

        // Transfer Ether to seller
        payable(listing.seller).transfer(msg.value);

        emit Purchased(listingId, msg.sender, amount);
    }
}