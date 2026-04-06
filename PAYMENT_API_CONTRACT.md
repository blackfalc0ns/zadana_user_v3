# payment

## Endpoints
- `GET /checkout`
- `POST /checkout/promo-code`
- `DELETE /checkout/promo-code`
- `POST /checkout/place-order`

## Get Checkout Response
```json
{
  "order_summary": {
    "items_count": 0,
    "items": [
      {
        "id": "string",
        "name": "string",
        "quantity": 1,
        "price": 0,
        "image_url": "string"
      }
    ]
  },
  "selected_address": {
    "id": "string",
    "label": "string",
    "address_line": "string",
    "is_selected": true,
    "estimated_delivery_minutes": 45
  },
  "payment_methods": [
    {
      "id": "card",
      "name": "Credit/Debit Card",
      "subtitle": "Visa, Mastercard, Mada",
      "is_selected": true
    },
    {
      "id": "apple_pay",
      "name": "Apple Pay",
      "subtitle": "Fast and secure payment",
      "is_selected": false
    },
    {
      "id": "cash",
      "name": "Cash on Delivery",
      "subtitle": "Pay cash when order arrives",
      "is_selected": false
    },
    {
      "id": "bank",
      "name": "Bank Transfer",
      "subtitle": "string",
      "is_selected": false
    }
  ],
  "promo_code": {
    "code": "string",
    "discount_amount": 0,
    "is_applied": false
  },
  "price_breakdown": {
    "subtotal": 0,
    "shipping_cost": 0,
    "discount_amount": 0,
    "total": 0,
    "currency": "SAR"
  }
}
```

## Apply Promo Code Request
```json
{
  "code": "string"
}
```

## Apply Promo Code Response
```json
{
  "message": "promo code applied successfully",
  "promo_code": {
    "code": "string",
    "discount_amount": 0,
    "is_applied": true
  },
  "price_breakdown": {
    "subtotal": 0,
    "shipping_cost": 0,
    "discount_amount": 0,
    "total": 0,
    "currency": "SAR"
  }
}
```

## Remove Promo Code Response
```json
{
  "message": "promo code removed successfully",
  "promo_code": {
    "code": null,
    "discount_amount": 0,
    "is_applied": false
  },
  "price_breakdown": {
    "subtotal": 0,
    "shipping_cost": 0,
    "discount_amount": 0,
    "total": 0,
    "currency": "SAR"
  }
}
```

## Place Order Request
```json
{
  "address_id": "string",
  "payment_method_id": "card",
  "promo_code": "string"
}
```

## Place Order Response
```json
{
  "message": "order placed successfully",
  "order": {
    "id": "string",
    "status": "pending",
    "total": 0,
    "payment_method_id": "card"
  }
}
```

## Notes
- `GET /checkout` is used to build the payment screen before confirming the order.
- selected address is shown in the shipping card, but addresses themselves can have a separate addresses contract later.
- `POST /checkout/promo-code` is used when the user applies a promo code.
- `DELETE /checkout/promo-code` is used when the user removes an applied promo code.
- `POST /checkout/place-order` is used when the user taps the checkout button.
- supported payment methods in the current UI are: `card`, `apple_pay`, `cash`, and `bank`.
- `image_url` can be empty string or `null`.
