# OneSignal Order Status Push Diagnostics

## Current assessment

The backend payload shared on 2026-04-23 is structurally a visible push notification:

- It targets OneSignal users by `include_aliases.external_id`
- It includes both `headings` and `contents`
- It includes order metadata in `data`
- It uses `existing_android_channel_id`, which is the correct OneSignal field when the Android channel is created programmatically in the app

Because of that, this payload should be able to display in:

- foreground
- background
- killed / terminated

If order status notifications still do not appear in killed state while this exact payload is being sent, the most likely causes are:

- the actual request sent from the backend differs from the logged example
- the message is not reaching the expected OneSignal user tied to `external_id`
- the visible notification observed in foreground/background is coming from the app's SignalR + local notification path rather than from OneSignal push delivery

## Reference payload

```json
{
  "app_id": "e557da4e-947b-468b-ab5b-37c552c35dca",
  "target_channel": "push",
  "include_aliases": {
    "external_id": ["<user-id>"]
  },
  "headings": {
    "en": "Order Accepted",
    "ar": "تم قبول الطلب"
  },
  "contents": {
    "en": "Your order #ORD-123 has been accepted by the vendor",
    "ar": "تم قبول طلبك رقم ORD-123 من قبل التاجر"
  },
  "existing_android_channel_id": "zadana_heads_up_notifications",
  "priority": 10,
  "android_accent_color": "FF127C8C",
  "content_available": true,
  "mutable_content": true,
  "isAndroid": true,
  "isIos": true,
  "isAnyWeb": false,
  "data": {
    "notificationId": "<guid>",
    "type": "order_status_changed",
    "referenceId": "<order-guid>",
    "orderId": "<order-guid>",
    "orderNumber": "ORD-123",
    "vendorId": "<vendor-guid>",
    "oldStatus": "PendingVendorAcceptance",
    "newStatus": "Accepted",
    "actorRole": "vendor",
    "action": "status_changed",
    "targetUrl": "/orders/<order-guid>",
    "click_action": "FLUTTER_NOTIFICATION_CLICK"
  }
}
```

## App-side diagnostics added

The app now logs notification source and payload summaries so QA can distinguish:

- OneSignal push received in foreground
- OneSignal push clicked
- SignalR realtime notification received
- SignalR realtime local notification queued

## QA checklist

1. Send the order status push from backend for a real logged-in customer.
2. Verify OneSignal Message Report marks the push as delivered to the expected user.
3. Test with the app in foreground and check the logs for:
   - `OneSignal push received in foreground`
   - `Notifications SignalR event received`
4. Kill the app completely and send again.
5. If nothing appears in killed state:
   - compare the actual outbound backend request body with the payload above
   - confirm the targeted `external_id` matches the customer id used in `OneSignal.login(customerId)`
   - confirm the push was truly delivered by OneSignal and not only mirrored through SignalR while the app was alive
