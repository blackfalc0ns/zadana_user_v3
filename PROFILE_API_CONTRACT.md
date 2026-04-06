# profile

## Endpoints
- `GET /profile`
- `PATCH /profile`
- `POST /logout`

## Get Profile Response
```json
{
  "user": {
    "id": "string",
    "full_name": "string",
    "phone_number": "string",
    "email": "string"
  },
  "stats": {
    "orders_count": 0,
    "addresses_count": 0,
    "profile_completion_status": "string"
  }
}
```

## Update Profile Request
```json
{
  "full_name": "string",
  "phone_number": "string",
  "email": "string"
}
```

## Update Profile Response
```json
{
  "message": "profile updated successfully",
  "user": {
    "id": "string",
    "full_name": "string",
    "phone_number": "string",
    "email": "string"
  }
}
```

## Logout Response
```json
{
  "message": "logged out successfully"
}
```

## Notes
- `GET /profile` is used to build the profile dashboard screen.
- `stats.orders_count` matches the orders card in profile.
- `stats.addresses_count` matches the addresses card in profile.
- `stats.profile_completion_status` matches the profile status card like `complete`.
- `PATCH /profile` is for editing the basic profile data.
- language and notifications are managed locally, so they are not included in profile API.
- orders, addresses, help/support, faq, and privacy pages can have separate contracts later.
