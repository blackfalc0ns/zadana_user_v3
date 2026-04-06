# search

## Endpoint
- `GET /products/search`

## Query Params
- `query`: `string`
- `category_id`: `string` optional
- `brand_id`: `string` optional
- `min_price`: `number` optional
- `max_price`: `number` optional
- `sort`: `newest|price_low_high|price_high_low|best_selling|highest_rated|alphabetical` optional
- `page`: `number` optional
- `per_page`: `number` optional

## Example Request
```http
GET /products/search?query=milk&category_id=cat5&brand_id=juhayna&sort=price_low_high&page=1&per_page=20
```

## Response
```json
{
  "query": "string",
  "total": 0,
  "page": 1,
  "per_page": 20,
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
      "is_favorite": false,
      "unit": "string",
      "is_discounted": false
    }
  ]
}
```

## Notes
- this endpoint is shared between home search and shopping/category search.
- `category_id`, `brand_id`, price filters, and `sort` are optional.
- `old_price`, `rating`, `review_count`, `discount`, and `unit` can be `null`.
- `image_url` can be empty string or `null`.
