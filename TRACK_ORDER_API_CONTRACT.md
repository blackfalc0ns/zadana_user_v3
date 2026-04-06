# track order

## Endpoint
- `GET /orders/{order_id}/tracking`

## Tracking Response
```json
{
  "order": {
    "id": "string",
    "status": "pending|processing|out_for_delivery|delivered|cancelled|returning"
  },
  "estimated_delivery": {
    "datetime": "ISO8601",
    "formatted": "string"
  },
  "driver": {
    "id": "string",
    "name": "string",
    "phone_number": "string",
    "subtitle": "string"
  },
  "timeline": [
    {
      "id": "string",
      "title": "string",
      "time": "string",
      "is_active": true,
      "is_completed": true
    }
  ]
}
```

## Example Response
```json
{
  "order": {
    "id": "#ZD-2048",
    "status": "processing"
  },
  "estimated_delivery": {
    "datetime": "2026-09-03T11:00:00Z",
    "formatted": "03 September 2026, 11:00 AM"
  },
  "driver": {
    "id": "drv_1",
    "name": "Mohamed",
    "phone_number": "+201000000000",
    "subtitle": "Delivery driver assigned to your order today"
  },
  "timeline": [
    {
      "id": "step_1",
      "title": "Order received",
      "time": "2026-09-03 09:00",
      "is_active": true,
      "is_completed": true
    },
    {
      "id": "step_2",
      "title": "Preparing order",
      "time": "2026-09-03 09:30",
      "is_active": true,
      "is_completed": true
    },
    {
      "id": "step_3",
      "title": "Out for delivery",
      "time": "",
      "is_active": false,
      "is_completed": false
    },
    {
      "id": "step_4",
      "title": "Delivered",
      "time": "",
      "is_active": false,
      "is_completed": false
    }
  ]
}
```

## Notes
- this endpoint is used in the track order screen.
- `estimated_delivery.formatted` can be returned directly if backend wants to control display text.
- `driver` can be `null` if no driver is assigned yet.
- `timeline` is displayed as the order progress list.
- `time` can be empty for steps not reached yet.
