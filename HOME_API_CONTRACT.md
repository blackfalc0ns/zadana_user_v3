# home

## Endpoints
- `GET /home`
- `GET /home/banners`
- `GET /home/categories`
- `GET /home/special-offers`
- `GET /home/recommended`
- `GET /home/best-selling`
- `GET /home/brands`
- `GET /home/featured-products`
- `GET /home/explore-more`

## Home Response
```json
{
  "deliver_to_label": "string",
  "location": "string",
  "notifications_count": 0
}
```

## Banners Response
```json
[
  {
    "id": "string",
    "tag": "string",
    "title": "string",
    "subtitle": "string",
    "action_label": "string",
    "image_url": "string"
  }
]
```

## Categories Response
```json
[
  {
    "id": "string",
    "name": "string",
    "image_url": "string"
  }
]
```

## Special Offers Response
```json
[
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
    "is_discounted": true
  }
]
```

## Recommended Response
```json
[
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
```

## Best Selling Response
```json
[
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
```

## Brands Response
```json
[
  {
    "id": "string",
    "name": "string",
    "logo": "string",
    "cover_image": "string",
    "product_count": 0,
    "description": "string"
  }
]
```

## Featured Products Response
```json
[
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
```

## Explore More Response
```json
[
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
```

## Notes
- product shape is the same in `special-offers`, `recommended`, `best-selling`, `featured-products`, and `explore-more`.
- `old_price`, `rating`, `review_count`, `discount`, `unit`, `cover_image`, and `description` can be `null`.
- `image_url` can be empty string or `null`.
- `notifications_count` is shown in the home app bar.
- `deliver_to_label` and `location` are shown in the home header card.
