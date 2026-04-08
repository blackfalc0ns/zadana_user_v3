# Login Feature

This feature follows a layered clean architecture flow for login:

`presentation -> domain -> data -> remote api`

## Folder Structure

- `presentation/`
  Handles UI, form input, state, and user interaction.
- `domain/`
  Contains entities, repository contract, and use case.
- `data/`
  Contains DTOs, mappers, remote data source, and repository implementation.

## Backend Integration Flow

### 1. Presentation

The login screen builds the form in:

- `presentation/pages/login_screen.dart`
- `presentation/widget/sign_in_form.dart`

Right now, the form is still navigating directly to `AppRoutes.mainShell` and the actual `LoginViewModel` dispatch is commented out inside:

- `presentation/widget/sign_in_form.dart`
- `presentation/manager/login_view_model.dart`

So the backend integration structure exists, but the form is not fully wired to the live login flow yet.

### 2. Domain

The domain layer defines the business contract:

- `domain/entities/login_request_entity.dart`
- `domain/entities/login_response_entity.dart`
- `domain/entities/tokens_entity.dart`
- `domain/entities/user_entity.dart`
- `domain/repo/login_repository.dart`
- `domain/usecase/login_usecase.dart`

Flow:

1. UI creates `LoginRequestEntity`.
2. `LoginUseCase` calls `LoginRepository`.
3. Repository returns `ApiResult<LoginResponseEntity>`.

## 3. Data Layer

### Request DTO

`LoginRequestModelDto` converts the domain request into the API request body:

- `data/models/login_request_model_dto.dart`

### Remote Data Source

The remote contract is defined in:

- `data/data_source/login_remote_data_source.dart`

The implementation delegates to Retrofit `ApiServices`:

- `data/data_source/login_remote_data_source_impl.dart`

### API Call

The actual endpoint call is in:

- `lib/core/network/api_services.dart`

Method used:

```dart
@POST(EndPoints.login)
Future<LoginResponseModelDto> login(@Body() LoginRequestModelDto request);
```

### Repository

Repository implementation:

- `data/repo/login_repository_impl.dart`

Responsibilities:

1. Convert request entity to DTO.
2. Call remote data source.
3. Save tokens using `TokenService` if they exist.
4. Convert response DTO to domain entity.
5. Wrap the whole process with `safeApiCall`.

## Response Models

The response side is now nullable-safe to support partially missing backend payloads.

Updated files:

- `data/models/login_response_model_dto.dart`
- `data/models/tokens_model_dto.dart`
- `data/models/user_model_dto.dart`
- `domain/entities/login_response_entity.dart`
- `domain/entities/tokens_entity.dart`
- `domain/entities/user_entity.dart`

That means:

- `tokens` can be `null`
- `user` can be `null`
- `accessToken` can be `null`
- `refreshToken` can be `null`
- all `user` fields can be `null`

Example expected response:

```json
{
  "tokens": {
    "accessToken": "token-value",
    "refreshToken": "refresh-value"
  },
  "user": {
    "id": "123",
    "fullName": "Test User",
    "email": "test@example.com",
    "phone": "01000000000",
    "role": "customer"
  }
}
```

Example partial response that is now handled safely:

```json
{
  "tokens": null,
  "user": {
    "id": "123",
    "fullName": null,
    "email": "test@example.com",
    "phone": null,
    "role": "customer"
  }
}
```

## Important Note

If you want the login feature to be fully connected to the backend from the screen itself, the next step is to reconnect:

- `LoginViewModel`
- `LoginEvent`
- form submit in `sign_in_form.dart`

Right now the architecture is prepared, but the screen submit action is still using local navigation instead of calling the use case.
