# category

## Endpoints
- `GET /categories`
- `GET /categories/{category_id}/filters`
- `GET /categories/{category_id}/products`

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

## Category Filters Response
```json
{
  "category": {
    "id": "string",
    "name": "string"
  },
  "subcategories": [
    {
      "id": "string",
      "name": "string"
    }
  ],
  "product_types": [
    {
      "id": "string",
      "name": "string"
    }
  ],
  "parts": [
    {
      "id": "string",
      "name": "string",
      "product_type_id": "string"
    }
  ],
  "quantities": [
    {
      "id": "string",
      "name": "string"
    }
  ],
  "brands": [
    {
      "id": "string",
      "name": "string",
      "logo_url": "string"
    }
  ],
  "price_range": {
    "min": 0,
    "max": 1000
  },
  "sort_options": [
    {
      "label": "string",
      "value": "newest|price_low_high|price_high_low|best_selling|highest_rated|alphabetical"
    }
  ]
}
```

## Category Products Query Params
- `subcategory_id`: `string` optional
- `product_type_id`: `string` optional
- `part_id`: `string` optional
- `quantity_id`: `string` optional
- `brand_id`: `string` optional
- `min_price`: `number` optional
- `max_price`: `number` optional
- `sort`: `newest|price_low_high|price_high_low|best_selling|highest_rated|alphabetical` optional
- `page`: `number` optional
- `per_page`: `number` optional

## Default Category Products Request
```http
GET /categories/{category_id}/products
```

## Example Default Requests
```http
GET /categories/cat1/products
GET /categories/cat2/products
```

## Default Behavior
- if no query params are sent, the API should return all products for the selected category.
- example: `GET /categories/cat1/products` returns all `vegetables` products.
- example: `GET /categories/cat2/products` returns all `fruits` products.
- sorting is optional; if `sort` is not sent, the backend returns the default order.
- filtering is optional; if no filter params are sent, no filters are applied.

## Example Request
```http
GET /categories/cat5/products?product_type_id=full_fat&brand_id=juhayna&min_price=10&max_price=100&sort=price_low_high&page=1&per_page=20
```

## Category Products Response
```json
{
  "category": {
    "id": "string",
    "name": "string"
  },
  "applied_filters": {
    "subcategory_id": "string",
    "product_type_id": "string",
    "part_id": "string",
    "quantity_id": "string",
    "brand_id": "string",
    "min_price": 0,
    "max_price": 1000,
    "sort": "string"
  },
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
- `GET /categories` is used to build the top category chips in the shopping screen.
- `GET /categories/{category_id}/filters` returns the metadata needed to build the filter bottom sheet.
- `GET /categories/{category_id}/products` returns the products grid with filtering, sorting, and pagination.
- `GET /categories/{category_id}/products` without params returns all products of that category by default.
- `subcategory_id`, `product_type_id`, `part_id`, `quantity_id`, and `brand_id` are optional.
- `old_price`, `rating`, `review_count`, `discount`, `unit`, and `logo_url` can be `null`.
- `image_url` can be empty string or `null`.
- search should use the separate file: [SEARCH_API_CONTRACT.md](/d:/projects/zadana_user_v3/SEARCH_API_CONTRACT.md)
