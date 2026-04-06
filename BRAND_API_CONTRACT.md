# brand

## Endpoints
- `GET /brands`
- `GET /brands/{brand_id}`
- `GET /brands/{brand_id}/filters`
- `GET /brands/{brand_id}/products`

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

## Brand Details Response
```json
{
  "id": "string",
  "name": "string",
  "logo": "string",
  "cover_image": "string",
  "product_count": 0,
  "description": "string"
}
```

## Brand Filters Response
```json
{
  "brand": {
    "id": "string",
    "name": "string"
  },
  "categories": [
    {
      "id": "string",
      "name": "string"
    }
  ],
  "subcategories": [
    {
      "id": "string",
      "name": "string",
      "category_id": "string"
    }
  ],
  "units": [
    {
      "id": "string",
      "name": "string"
    }
  ],
  "price_range": {
    "min": 0,
    "max": 500
  },
  "sort_options": [
    {
      "label": "string",
      "value": "bestSellers|priceLowToHigh|priceHighToLow|newest"
    }
  ]
}
```

## Brand Products Query Params
- `category_id`: `string` optional
- `subcategory_id`: `string` optional
- `unit_id`: `string` optional
- `min_price`: `number` optional
- `max_price`: `number` optional
- `sort`: `bestSellers|priceLowToHigh|priceHighToLow|newest` optional
- `page`: `number` optional
- `per_page`: `number` optional

## Default Brand Products Request
```http
GET /brands/{brand_id}/products
```

## Example Request
```http
GET /brands/juhayna/products?category_id=dairy&subcategory_id=milk&unit_id=1_liter&min_price=10&max_price=100&sort=priceLowToHigh&page=1&per_page=20
```

## Brand Products Response
```json
{
  "brand": {
    "id": "string",
    "name": "string"
  },
  "applied_filters": {
    "category_id": "string",
    "subcategory_id": "string",
    "unit_id": "string",
    "min_price": 0,
    "max_price": 500,
    "sort": "string"
  },
  "total": 0,
  "page": 1,
  "per_page": 20,
  "items": [
    {
      "id": "string",
      "name": "string",
      "brand_id": "string",
      "brand_name": "string",
      "price": 0,
      "old_price": 0,
      "image_url": "string",
      "rating": 0,
      "review_count": 0,
      "discount": "string",
      "is_favorite": false,
      "is_in_stock": true,
      "unit": "string",
      "category": "string",
      "subcategory": "string",
      "size": "string",
      "is_best_seller": false,
      "created_at": "ISO8601"
    }
  ]
}
```

## Notes
- `GET /brands` is used for the brands section in home and any all-brands page later.
- `GET /brands/{brand_id}` is used for the header section of the brand page.
- `GET /brands/{brand_id}/filters` is used to build the brand filter bottom sheet.
- `GET /brands/{brand_id}/products` without params returns all brand products by default.
- category chip row on the brand page can use the `categories` list from filters response.
- `old_price`, `rating`, `review_count`, `discount`, `unit`, `category`, `subcategory`, `size`, `created_at`, `cover_image`, and `description` can be `null`.
- `image_url` can be empty string or `null`.
