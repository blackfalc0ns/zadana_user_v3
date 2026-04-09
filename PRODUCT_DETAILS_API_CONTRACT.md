# product details

## Endpoint
- `GET /products/{product_id}`

## Product Details Response
```json
{
  "id": "string",
  "name": "string",
  "store": "string",
  "price": 0,
  "old_price": 0,
  "image_url": "string",
  "images": [
    "string"
  ],
  "rating": 0,
  "review_count": 0,
  "discount": "string",
  "is_favorite": false,
  "unit": "string",
  "is_discounted": false,
  "description": "string",
  "vendor_prices": [
    {
      "id": "string",
      "name": "string",
      "logo_url": "string",
      "price": 0,
      "old_price": 0,
      "is_discounted": false
    }
  ],
  "similar_products": [
    {
      "id": "string",
      "name": "string",
      "store": "string",
      "price": 0,
      "old_price": 0,
      "image_url": "string",
      "rating": 0,
      "review_count": 0,
      "discount": "string",
      "is_favorite": false,
      "unit": "string",
      "is_discounted": false
    }
  ]
}
```

## Notes
- `GET /products/{product_id}` is used when the user opens product details from home, category, search, favorites, or cart.
- the top-level product fields keep the same product card shape already used in home, category, search, and favorites.
- `images` is used for the main product gallery; it can contain one image only if no extra gallery images are available.
- `vendor_prices` is used for the price comparison section across different stores/vendors.
- `similar_products` is used for the horizontal similar products section at the bottom of the screen.
- add to cart from product details should use: [CART_API_CONTRACT.md](/d:/projects/zadana_user_v3/CART_API_CONTRACT.md)
- favorite toggle from product details should use: [FAVORITES_API_CONTRACT.md](/d:/projects/zadana_user_v3/FAVORITES_API_CONTRACT.md)
- `old_price`, `rating`, `review_count`, `discount`, `unit`, and `logo_url` can be `null`.
- `image_url` can be empty string or `null`.
- `images` can be an empty array if the backend only returns `image_url`.
