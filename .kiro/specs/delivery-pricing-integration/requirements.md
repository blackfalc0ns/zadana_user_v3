# Requirements Document

## Introduction

This feature integrates the new backend two-leg delivery pricing system into the Zadana customer app (zadana_user_v3). The backend now calculates delivery fees using a driver→vendor + vendor→customer model, but the customer app must only display the aggregated total delivery fee from the backend response (`summary.shipping_cost`). The app must never calculate delivery pricing locally and must never expose the two-leg breakdown to the customer.

## Glossary

- **Checkout_Screen**: The payment/checkout page where the customer reviews their order, selects address, delivery slot, payment method, and confirms the order
- **Order_Details_Screen**: The page displaying details of a previously placed order including price summary
- **Checkout_Summary_API**: The backend endpoint `GET /api/checkout/summary` that returns the full checkout summary including delivery pricing
- **Shipping_Cost**: The total delivery fee returned in `summary.shipping_cost` from the Checkout_Summary_API response
- **Pricing_Mode**: A field in the API response indicating whether the delivery pricing is `"live"` (real-time calculated) or `"estimated"` (fallback estimate)
- **Delivery_Breakdown**: The internal backend object containing `driver_to_vendor` and `vendor_to_customer` leg details — must not be displayed to the customer
- **Payment_View_Model**: The BLoC/Cubit managing checkout state and API interactions in the payment feature

## Requirements

### Requirement 1: Display Backend Delivery Fee on Checkout

**User Story:** As a customer, I want to see the delivery fee on the checkout screen, so that I know how much delivery costs before placing my order.

#### Acceptance Criteria

1. WHEN the Checkout_Summary_API returns a successful response, THE Checkout_Screen SHALL display `summary.shipping_cost` as the delivery fee formatted to exactly 2 decimal places
2. WHEN the Checkout_Summary_API returns a successful response, THE Checkout_Screen SHALL display `summary.total` as the final order total formatted to exactly 2 decimal places
3. WHEN the Checkout_Summary_API returns a successful response, THE Checkout_Screen SHALL display `summary.subtotal` as the items subtotal formatted to exactly 2 decimal places
4. WHEN the Checkout_Summary_API returns a successful response, THE Checkout_Screen SHALL display `summary.discount` as the discount amount formatted to exactly 2 decimal places, prefixed with a minus sign
5. WHEN the Checkout_Summary_API returns a successful response, THE Checkout_Screen SHALL display the localized label for `summary.currency` adjacent to every displayed price value
6. IF the Checkout_Summary_API returns an error response or the request times out within 30 seconds, THEN THE Checkout_Screen SHALL display an error message indicating the summary could not be loaded and SHALL provide a retry action
7. WHILE the Checkout_Summary_API request is in progress, THE Checkout_Screen SHALL display a loading indicator in place of the price breakdown section

### Requirement 2: Display Delivery Fee on Order Details

**User Story:** As a customer, I want to see the delivery fee on my order details, so that I can review the cost breakdown of a completed order.

#### Acceptance Criteria

1. WHEN order details are loaded, THE Order_Details_Screen SHALL display the shipping cost from `summary.shipping_cost` as a labeled row within the order summary section, formatted as the numeric value with exactly 2 decimal places followed by the currency symbol
2. WHEN order details are loaded, THE Order_Details_Screen SHALL display the order total from `summary.total` as a labeled row within the order summary section, formatted as the numeric value with exactly 2 decimal places followed by the currency symbol
3. WHEN order details are loaded AND `summary.shipping_cost` equals 0, THE Order_Details_Screen SHALL display the shipping cost row with a value of "0.00" followed by the currency symbol
4. THE Order_Details_Screen SHALL NOT display the two-leg delivery fee breakdown (driver_to_vendor, vendor_to_customer); only the single aggregated `summary.shipping_cost` value SHALL be shown to the customer

### Requirement 3: Fetch Checkout Summary from Backend API

**User Story:** As a customer, I want the checkout to load pricing from the server, so that I always see accurate and up-to-date delivery fees.

#### Acceptance Criteria

1. WHEN the checkout screen is opened, THE Payment_View_Model SHALL call `GET /api/checkout/summary` with `vendor_id`, `address_id`, and `delivery_slot_id` query parameters and emit a loading state until the response is received or the request fails
2. WHEN the selected address changes to a different address than the currently selected one, THE Payment_View_Model SHALL re-fetch the checkout summary from the Checkout_Summary_API including the new `address_id`
3. WHEN the selected delivery slot changes to a different slot than the currently selected one, THE Payment_View_Model SHALL re-fetch the checkout summary from the Checkout_Summary_API including the new `delivery_slot_id`
4. WHEN the selected payment method changes to a different method than the currently selected one, THE Payment_View_Model SHALL re-fetch the checkout summary from the Checkout_Summary_API including the new `payment_method` parameter
5. WHEN the vendor context changes, THE Payment_View_Model SHALL re-fetch the checkout summary from the Checkout_Summary_API including the new `vendor_id`
6. WHILE a checkout summary re-fetch is in progress, THE Payment_View_Model SHALL emit a refreshing state that the UI can use to indicate loading to the user
7. IF the Checkout_Summary_API request fails, THEN THE Payment_View_Model SHALL emit a failure state containing the error information and preserve any previously loaded checkout summary data
8. IF the selected payment method is the same as the currently active payment method, THEN THE Payment_View_Model SHALL NOT trigger a re-fetch

### Requirement 4: No Local Delivery Fee Calculation

**User Story:** As a product owner, I want the app to rely solely on backend pricing, so that pricing logic is centralized and consistent across platforms.

#### Acceptance Criteria

1. THE Checkout_Screen SHALL obtain delivery fee values exclusively from the Checkout_Summary_API response fields: `summary.shipping_cost` and `delivery_breakdown.total_delivery`
2. THE Checkout_Screen SHALL NOT compute delivery fees from distance, city, zone, or any local data
3. IF the Checkout_Summary_API response is received and the `delivery_breakdown` field is null or absent, THEN THE Checkout_Screen SHALL display the `summary.shipping_cost` value from the response as the delivery fee without performing any local calculation
4. THE Payment_View_Model SHALL NOT invoke any local function or formula that derives delivery fees from distance, city, zone, or fixed-rate tables; all delivery fee values displayed or used in totals SHALL originate from the Checkout_Summary_API response
5. WHEN the Checkout_Summary_API response is received, THE Checkout_Screen SHALL render the delivery fee using only the `summary.shipping_cost` returned by the API, with no client-side additions or modifications to the amounts

### Requirement 5: Hide Delivery Breakdown from Customer

**User Story:** As a product owner, I want the two-leg delivery breakdown hidden from customers, so that the internal pricing model remains transparent only to operations.

#### Acceptance Criteria

1. THE Checkout_Screen SHALL NOT display `delivery_breakdown.driver_to_vendor` details including any sub-fields (fee, distance_km) present in the API response
2. THE Checkout_Screen SHALL NOT display `delivery_breakdown.vendor_to_customer` details including any sub-fields (fee, distance_km) present in the API response
3. THE Checkout_Screen SHALL NOT display the individual leg fees of the delivery breakdown to the customer
4. THE Checkout_Screen SHALL display exactly one delivery fee line item whose value equals the aggregated `shipping_cost` field from the checkout summary
5. WHEN the API response contains a `delivery_breakdown` object, THE Checkout_Screen SHALL ignore those fields for rendering purposes and display only the single aggregated delivery fee line

### Requirement 6: Handle Estimated Pricing Mode

**User Story:** As a customer, I want to still place orders when pricing is estimated, so that temporary backend issues do not block my purchase.

#### Acceptance Criteria

1. WHEN Pricing_Mode is `"estimated"`, THE Checkout_Screen SHALL keep the place-order button enabled and allow the customer to submit the order
2. WHEN Pricing_Mode is `"estimated"`, THE Checkout_Screen SHALL display a non-blocking informational note adjacent to the delivery fee indicating that the displayed fee is an estimate and the final amount may differ
3. WHEN Pricing_Mode is `"live"`, THE Checkout_Screen SHALL NOT display any estimation note
4. IF Pricing_Mode is null or contains an unrecognized value, THEN THE Checkout_Screen SHALL treat it as `"live"` and SHALL NOT display any estimation note nor block order placement

### Requirement 7: Handle API Errors Gracefully

**User Story:** As a customer, I want clear feedback when pricing cannot be loaded, so that I understand why I cannot proceed with checkout.

#### Acceptance Criteria

1. IF the Checkout_Summary_API returns an error, THEN THE Checkout_Screen SHALL display an error message indicating the nature of the failure (network unavailability, timeout, or server error) in place of the checkout summary content
2. IF the Checkout_Summary_API returns an error, THEN THE Checkout_Screen SHALL display a retry button that, when tapped, re-fetches the checkout summary from the API
3. IF the Checkout_Summary_API returns an error, THEN THE Checkout_Screen SHALL disable the Place Order button until a successful checkout summary response is received
4. WHEN the customer taps the retry button, THE Checkout_Screen SHALL display a loading indicator until the API responds or the request times out within 30 seconds
5. WHILE the Checkout_Summary_API request is in progress, THE Checkout_Screen SHALL NOT display the retry button or the Place Order button as enabled
