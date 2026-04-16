# checkout

## Endpoints
- `GET /checkout/summary`
- `POST /checkout/promo-code`
- `DELETE /checkout/promo-code`
- `POST /orders`

## Checkout Summary Query Params
- `address_id`: `string` optional
- `delivery_slot_id`: `string` optional

## Checkout Summary Response
```json
{
  "cart": {
    "items_count": 0,
    "total_quantity": 0,
    "items": [
      {
        "id": "string",
        "product_id": "string",
        "name": "string",
        "image_url": "string",
        "unit": "string",
        "quantity": 1,
        "price": 0,
        "total_price": 0
      }
    ]
  },
  "selected_address": {
    "id": "string",
    "label": "home|work|other",
    "address_line": "string",
    "is_default": true
  },
  "delivery_slots": [
    {
      "id": "string",
      "label": "string",
      "start_at": "ISO8601",
      "end_at": "ISO8601",
      "is_available": true,
      "is_selected": true
    }
  ],
  "payment_methods": [
    {
      "code": "card|apple_pay|cash|bank",
      "label": "string",
      "is_available": true,
      "is_default": false
    }
  ],
  "promo_code": {
    "code": "string",
    "discount_type": "fixed|percentage",
    "discount_value": 0,
    "discount_amount": 0
  },
  "summary": {
    "subtotal": 0,
    "shipping_cost": 0,
    "discount": 0,
    "total": 0,
    "currency": "SAR"
  }
}
```

## Apply Promo Code Request
```json
{
  "code": "SAVE15"
}
```

## Apply Promo Code Response
```json
{
  "message": "promo code applied successfully",
  "promo_code": {
    "code": "SAVE15",
    "discount_type": "fixed",
    "discount_value": 15,
    "discount_amount": 15
  },
  "summary": {
    "subtotal": 125.5,
    "shipping_cost": 0,
    "discount": 15,
    "total": 110.5,
    "currency": "SAR"
  }
}
```

## Remove Promo Code Response
```json
{
  "message": "promo code removed successfully",
  "summary": {
    "subtotal": 125.5,
    "shipping_cost": 0,
    "discount": 0,
    "total": 125.5,
    "currency": "SAR"
  }
}
```

## Place Order Request
```json
{
  "address_id": "string",
  "delivery_slot_id": "string",
  "payment_method": "card|apple_pay|cash|bank",
  "promo_code": "string",
  "notes": "string"
}
```

## Place Order Response
```json
{
  "message": "order placed successfully",
  "order": {
    "id": "string",
    "created_at": "ISO8601",
    "status": "pending|processing",
    "payment_method": "card|apple_pay|cash|bank",
    "payment_status": "pending|paid|failed",
    "total_price": 0
  }
}
```

## Notes
- `GET /checkout/summary` is used when the user opens the checkout/payment screen from cart.
- `address_id` can be sent to recalculate shipping or availability when the user changes the delivery address.
- `delivery_slot_id` can be sent to refresh the final total and selected slot state.
- `payment_methods` returns the methods shown in the payment method section.
- `POST /checkout/promo-code` is used when the user taps `apply` in checkout.
- `DELETE /checkout/promo-code` is used when the user removes an already applied promo code.
- `POST /orders` is used by the final `checkout` button to place the order.
- after successful `POST /orders`, the cart can be cleared by the backend automatically.
- the created order should appear later in: [MY_ORDERS_API_CONTRACT.md](/d:/projects/zadana_user_v3/MY_ORDERS_API_CONTRACT.md)
- cart items shown in checkout should stay aligned with: [CART_API_CONTRACT.md](/d:/projects/zadana_user_v3/CART_API_CONTRACT.md)
- `selected_address` can be `null` if the user has no saved address yet.
- `promo_code` can be `null` if no code is applied.
- `image_url` and `unit` can be `null`.
