# my orders

## Endpoints
- `GET /orders/active`
- `GET /orders/completed`
- `GET /orders/returns`
- `GET /orders/{order_id}`
- `POST /orders/{order_id}/cancel`
- `POST /orders/{order_id}/complaints`
- `GET /orders/{order_id}/complaints`

## Active Orders Query Params
- `page`: `number` optional
- `per_page`: `number` optional

## Active Orders Response
```json
{
  "items": [
    {
      "id": "string",
      "created_at": "ISO8601",
      "total_price": 0,
      "status": "pending|processing|shipped|delivered|returning|cancelled",
      "items_count": 0,
      "items": [
        {
          "id": "string",
          "name": "string",
          "quantity": 1,
          "price": 0
        }
      ]
    }
  ],
  "page": 1,
  "per_page": 20,
  "total": 0
}
```

## Completed Orders Query Params
- `page`: `number` optional
- `per_page`: `number` optional

## Completed Orders Response
```json
{
  "items": [
    {
      "id": "string",
      "created_at": "ISO8601",
      "total_price": 0,
      "status": "delivered",
      "items_count": 0,
      "items": [
        {
          "id": "string",
          "name": "string",
          "quantity": 1,
          "price": 0
        }
      ]
    }
  ],
  "page": 1,
  "per_page": 20,
  "total": 0
}
```

## Returns Orders Query Params
- `page`: `number` optional
- `per_page`: `number` optional

## Returns Orders Response
```json
{
  "items": [
    {
      "id": "string",
      "created_at": "ISO8601",
      "total_price": 0,
      "status": "returning",
      "items_count": 0,
      "items": [
        {
          "id": "string",
          "name": "string",
          "quantity": 1,
          "price": 0
        }
      ]
    }
  ],
  "page": 1,
  "per_page": 20,
  "total": 0
}
```

## Example Requests
```http
GET /orders/active
GET /orders/completed
GET /orders/returns
```

## Order Details Response
```json
{
  "id": "string",
  "created_at": "ISO8601",
  "total_price": 0,
  "status": "pending|processing|shipped|delivered|returning|cancelled",
  "can_cancel": true,
  "items_count": 0,
  "summary": {
    "subtotal": 0,
    "shipping_cost": 0,
    "total": 0
  },
  "items": [
    {
      "id": "string",
      "name": "string",
      "quantity": 1,
      "price": 0
    }
  ]
}
```

## Cancel Order Request
```json
{
  "reason_code": "changed_my_mind",
  "reason": "string",
  "note": "string"
}
```

## Cancel Order Response
```json
{
  "message": "order cancelled successfully",
  "order": {
    "id": "string",
    "status": "cancelled"
  }
}
```

## Submit Complaint Request
```json
{
  "message": "string",
  "attachments": [
    {
      "file_name": "string",
      "file_url": "string"
    }
  ]
}
```

## Submit Complaint Response
```json
{
  "message": "complaint submitted successfully",
  "complaint": {
    "id": "string",
    "status": "submitted|in_review|resolved",
    "message": "string",
    "attachments": [
      {
        "file_name": "string",
        "file_url": "string"
      }
    ],
    "created_at": "ISO8601"
  }
}
```

## Get Complaint Response
```json
{
  "complaint": {
    "id": "string",
    "status": "submitted|in_review|resolved",
    "message": "string",
    "attachments": [
      {
        "file_name": "string",
        "file_url": "string"
      }
    ],
    "created_at": "ISO8601"
  }
}
```

## Notes
- `GET /orders/active` is used for the `الحالية` tab.
- `GET /orders/completed` is used for the `السابقة` tab.
- `GET /orders/returns` is used for the `المرتجعات` tab.
- `GET /orders/{order_id}` is used in order details page.
- `POST /orders/{order_id}/cancel` is used when the user cancels an order from details.
- `POST /orders/{order_id}/complaints` is used for `تقديم شكوى` from order details.
- `GET /orders/{order_id}/complaints` is used to show complaint status like `submitted`, `in_review`, or `resolved`.
- language and notifications are local settings, so they are not part of orders/profile API.
