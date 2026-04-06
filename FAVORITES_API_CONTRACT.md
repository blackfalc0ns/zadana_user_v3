# favorites

## Endpoints
- `GET /favorites`
- `POST /favorites`
- `DELETE /favorites/{product_id}`
- `DELETE /favorites`

## Get Favorites Response
```json
{
  "items": [
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
      "is_favorite": true,
      "unit": "string",
      "is_discounted": false
    }
  ],
  "summary": {
    "items_count": 0
  }
}
```

## Add To Favorites Request
```json
{
  "product_id": "string"
}
```

## Add To Favorites Response
```json
{
  "message": "product added to favorites successfully",
  "item": {
    "id": "string",
    "name": "string",
    "store": "string",
    "price": 0,
    "old_price": 0,
    "image_url": "string",
    "rating": 0,
    "review_count": 0,
    "discount": "string",
    "is_favorite": true,
    "unit": "string",
    "is_discounted": false
  },
  "summary": {
    "items_count": 0
  }
}
```

## Remove Favorite Response
```json
{
  "message": "product removed from favorites successfully",
  "summary": {
    "items_count": 0
  }
}
```

## Clear Favorites Response
```json
{
  "message": "favorites cleared successfully"
}
```

## Notes
- `GET /favorites` is used to build the favorites screen list/grid.
- `POST /favorites` is used when the user taps the favorite icon from home, category, search, or product details.
- `DELETE /favorites/{product_id}` is used to remove one product from favorites.
- `DELETE /favorites` is used for clear all favorites.
- `old_price`, `rating`, `review_count`, `discount`, and `unit` can be `null`.
- `image_url` can be empty string or `null`.
