# BitVenture Marketplace

**BitVenture Marketplace** is a decentralized e-commerce platform built on the [Stacks](https://www.stacks.co/) blockchain, enabling Bitcoin-native commerce through secure smart contracts. This smart contract system allows merchants to register brands, list products, and facilitate both direct sales and auction-based transactions. Consumers can purchase items or bid on auctions, leave reviews, and interact transparently on a trustless protocol.

## Features

- **Decentralized Brand Registry**  
  Merchants can register their brand identities and get verified by the contract owner.

- **Product Listings & Sales**  
  Products can be listed with detailed metadata for direct purchases in STX tokens.

- **Auction System**  
  Products can be listed in time-bound auctions with real-time bidding and settlement.

- **Review & Rating Mechanism**  
  Consumers can leave public reviews and ratings for products after interaction.

- **Platform Fee Infrastructure**  
  A configurable platform fee (default 2.5%) is applied on sales and auction settlements.

## Contract Details

- **Language**: [Clarity](https://docs.stacks.co/write-smart-contracts/clarity-overview)
- **Platform**: [Stacks Blockchain](https://stacks.co) — Bitcoin layer-2
- **Contract Type**: Marketplace / E-Commerce DApp

## Functional Overview

### Brand Management

- `register-brand(name)`: Register a new brand (unverified).
- `verify-brand(brand)`: Contract owner verifies a registered brand.

### Product Listings

- `list-product(name, description, price)`: List a product for direct sale.
- `purchase-product(product-id)`: Purchase a directly listed product.

### Auctions

- `create-auction(name, description, min-price, duration)`: List a product for auction.
- `place-bid(product-id, bid-amount)`: Place a bid on an active auction.
- `end-auction(product-id)`: Finalize the auction, transfer funds, and mark the product as sold.

### Reviews

- `add-review(product-id, rating, comment)`: Add a review for a product (rating ≤ 5).

### Read-Only Views

- `get-product(product-id)`
- `get-brand(brand)`
- `get-review(product-id, reviewer)`
- `get-auction(product-id)`

## Error Handling

The contract defines robust error codes for safety and transparency:

| Error Constant           | Code | Description                              |
|--------------------------|------|------------------------------------------|
| `err-owner-only`         | 100  | Only the contract owner can call         |
| `err-not-brand-owner`    | 101  | Unauthorized brand operation             |
| `err-invalid-price`      | 102  | Product price must be positive           |
| `err-listing-not-found`  | 103  | Invalid or non-existent listing          |
| `err-insufficient-funds` | 104  | Buyer has insufficient STX               |
| `err-auction-ended`      | 105  | Auction is already closed                |
| `err-bid-too-low`        | 106  | Bid amount is too low                    |
| `err-no-active-auction`  | 107  | No active auction found                  |
| `err-invalid-duration`   | 108  | Auction duration below minimum (10)      |
| `err-invalid-rating`     | 109  | Rating value is out of valid range       |
| `err-transfer-failed`    | 110  | STX transfer operation failed            |

## Security & Integrity

- Platform is designed for transparency and immutability.
- No third-party custody: STX transfers are on-chain and verifiable.
- Auctions are enforced by block height and cannot be manipulated post-creation.

## Extensibility

This contract can serve as a base for future upgrades such as:

- NFT integration for tokenized products
- Dispute resolution mechanisms
- On-chain delivery confirmation
- Enhanced moderation with DAO governance

## Author & Ownership

- **Contract Owner**: Defined at deployment (`contract-owner`)
- Only the owner can:
  - Verify brands
  - Receive platform fees

## Contributing

Interested in extending BitVenture Marketplace? Fork the repo, create a new branch, and submit a pull request with clear documentation of your changes.

## Contact

For issues or inquiries, please open a GitHub issue or contact the maintainers.
