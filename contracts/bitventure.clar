;; Title: BitVenture Marketplace
;; Summary: A decentralized marketplace for Bitcoin-based e-commerce on Stacks
;; 
;; This contract implements a full-featured decentralized marketplace that
;; allows merchants to register brands, list products for direct sale or auction,
;; and enables consumers to purchase products or participate in auctions.
;; Built on Stacks for Bitcoin compliance, it includes features such as:
;;  - Brand registration and verification system
;;  - Direct product listings and purchases
;;  - Auction system with bidding and settlement
;;  - Product review and rating system
;;  - Platform fee mechanism
;;
;; The marketplace is designed to be secure, transparent, and Bitcoin-aligned,
;; providing a robust foundation for e-commerce on the Stacks layer 2.

;; Constants 
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-brand-owner (err u101))
(define-constant err-invalid-price (err u102))
(define-constant err-listing-not-found (err u103))
(define-constant err-insufficient-funds (err u104))
(define-constant err-auction-ended (err u105))
(define-constant err-bid-too-low (err u106))
(define-constant err-no-active-auction (err u107))
(define-constant err-invalid-duration (err u108))
(define-constant err-invalid-rating (err u109))

;; Data Variables
(define-data-var platform-fee uint u25) ;; 2.5% fee

;; Data Maps
(define-map Brands principal 
  {
    name: (string-ascii 50),
    verified: bool,
    created-at: uint
  }
)

(define-map Products uint 
  {
    brand: principal,
    name: (string-ascii 100),
    description: (string-ascii 500),
    price: uint,
    available: bool,
    created-at: uint,
    is-auction: bool
  }
)

(define-map Auctions uint
  {
    end-block: uint,
    min-price: uint,
    highest-bid: uint,
    highest-bidder: (optional principal),
    is-active: bool
  }
)

(define-map Reviews {product-id: uint, reviewer: principal}
  {
    rating: uint,
    comment: (string-ascii 200),
    timestamp: uint
  }
)

;; Product ID counter
(define-data-var product-counter uint u0)

;; Brand Management Functions

;; Register a new brand
(define-public (register-brand (name (string-ascii 50)))
  (let
    ((brand-data {
      name: name,
      verified: false,
      created-at: stacks-block-height
    }))
    (ok (map-set Brands tx-sender brand-data))
  )
)

;; Verify a brand (owner only)
(define-public (verify-brand (brand principal))
  (if (is-eq tx-sender contract-owner)
    (let
      ((brand-data (unwrap! (map-get? Brands brand) 
                   (err err-not-brand-owner))))
      (ok (map-set Brands brand 
        (merge brand-data {verified: true}))))
    (err err-owner-only))
)

;; Direct Sale Functions

;; List a new product
(define-public (list-product 
    (name (string-ascii 100))
    (description (string-ascii 500))
    (price uint)
  )
  (let
    ((brand (unwrap! (map-get? Brands tx-sender) (err err-not-brand-owner)))
     (product-id (+ (var-get product-counter) u1)))
    
    (if (> price u0)
      (begin
        (var-set product-counter product-id)
        (ok (map-set Products product-id {
          brand: tx-sender,
          name: name,
          description: description,
          price: price,
          available: true,
          created-at: stacks-block-height,
          is-auction: false
        })))
      (err err-invalid-price)
    )
  )
)

;; Purchase a product
(define-public (purchase-product (product-id uint))
  (let
    ((product (unwrap! (map-get? Products product-id) (err err-listing-not-found)))
     (price (get price product))
     (brand (get brand product))
     (fee (/ (* price (var-get platform-fee)) u1000)))
    
    (if (and
          (get available product)
          (not (get is-auction product))
          (>= (stx-get-balance tx-sender) price))
      (begin
        (try! (stx-transfer? fee tx-sender contract-owner))
        (try! (stx-transfer? (- price fee) tx-sender brand))
        (map-set Products product-id 
          (merge product {available: false}))
        (ok true))
      (err err-insufficient-funds))
  )
)