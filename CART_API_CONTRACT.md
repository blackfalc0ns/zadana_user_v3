# cart

## Endpoints
- `GET /cart`
- `POST /cart/items`
- `PATCH /cart/items/{item_id}`
- `DELETE /cart/items/{item_id}`
- `DELETE /cart`

## Get Cart Response
```json
{
  "items": [
    {
      "id": "string",
      "product_id": "string",
      "name": "string",
      "image_url": "string",
      "unit": "string",
      "quantity": 1,
      "vendor_prices": [
        {
          "id": "string",
          "name": "string",
          "price": 0,
          "old_price": 0,
          "is_discounted": false
        }
      ]
    }
  ],
  "summary": {
    "items_count": 0,
    "total_quantity": 0
  }
}
```

## Add To Cart Request
```json
{
  "product_id": "string",
  "quantity": 1
}
```

## Add To Cart Response
```json
{
  "message": "added to cart successfully",
  "item": {
    "id": "string",
    "product_id": "string",
    "name": "string",
    "image_url": "string",
    "unit": "string",
    "quantity": 1,
    "vendor_prices": [
      {
        "id": "string",
        "name": "string",
        "price": 0,
        "old_price": 0,
        "is_discounted": false
      }
    ]
  },
  "summary": {
    "items_count": 0,
    "total_quantity": 0
  }
}
```

## Update Cart Item Request
```json
{
  "quantity": 2
}
```

## Update Cart Item Response
```json
{
  "message": "cart item updated successfully",
  "item": {
    "id": "string",
    "product_id": "string",
    "name": "string",
    "image_url": "string",
    "unit": "string",
    "quantity": 2,
    "vendor_prices": [
      {
        "id": "string",
        "name": "string",
        "price": 0,
        "old_price": 0,
        "is_discounted": false
      }
    ]
  },
  "summary": {
    "items_count": 0,
    "total_quantity": 0
  }
}
```

## Delete Cart Item Response
```json
{
  "message": "cart item removed successfully",
  "summary": {
    "items_count": 0,
    "total_quantity": 0
  }
}
```

## Clear Cart Response
```json
{
  "message": "cart cleared successfully"
}
```

## Notes
- `POST /cart/items` is the endpoint used by any `add to cart` button in home, category, search, favorites, and product details.
- if the same `product_id` already exists in cart, backend can increase its quantity instead of creating a duplicate row.
- `PATCH /cart/items/{item_id}` is used for increment/decrement quantity inside the cart screen.
- `DELETE /cart/items/{item_id}` is used when removing one product from cart.
- `DELETE /cart` is used for clear all cart.
- `old_price` can be `null`.
- `image_url` can be empty string or `null`.
