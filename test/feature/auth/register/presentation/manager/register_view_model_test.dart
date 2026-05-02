import 'package:flutter_test/flutter_test.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/entities/register_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/entities/register_response_entity.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/repo/register_repository.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/usecase/register_usecase.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_state.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_view_model.dart';

void main() {
  group('RegisterViewModel', () {
    test('emits loading then success when register succeeds', () async {
      final viewModel = RegisterViewModel(
        RegisterUseCase(repository: _SuccessfulRegisterRepository()),
      );

      final expectation = expectLater(
        viewModel.stream,
        emitsInOrder([
          predicate<RegisterState>(
            (state) => state.isLoading == true && state.errorMessage == null,
          ),
          predicate<RegisterState>(
            (state) =>
                state.isLoading == false &&
                state.isSuccess == true &&
                state.registerResponseEntity != null,
          ),
        ]),
      );

      await viewModel.register(_registerRequest);

      await expectation;
      await viewModel.close();
    });

    test('emits loading then user facing error when register fails', () async {
      final viewModel = RegisterViewModel(
        RegisterUseCase(repository: _FailingRegisterRepository()),
      );

      final expectation = expectLater(
        viewModel.stream,
        emitsInOrder([
          predicate<RegisterState>(
            (state) => state.isLoading == true && state.errorMessage == null,
          ),
          predicate<RegisterState>(
            (state) =>
                state.isLoading == false &&
                state.isSuccess == false &&
                state.errorMessage == 'Email already exists',
          ),
        ]),
      );

      await viewModel.register(_registerRequest);

      await expectation;
      await viewModel.close();
    });
  });
}

final _registerRequest = RegisterRequestEntity(
  fullName: 'Test User',
  email: 'test@example.com',
  phone: '01000000000',
  password: 'Password123',
  addressLine: 'Street 1',
  label: 'Home',
  buildingNo: '10',
  floorNo: '2',
  apartmentNo: '5',
  city: 'Cairo',
  area: 'Nasr City',
  latitude: 30.0,
  longitude: 31.0,
);

class _SuccessfulRegisterRepository implements RegisterRepository {
  const _SuccessfulRegisterRepository();

  @override
  Future<ApiResult<RegisterResponseEntity>> register(
    RegisterRequestEntity entity,
  ) async {
    return ApiSuccessResult(
      data: RegisterResponseEntity(
        id: '1',
        fullName: entity.fullName,
        email: entity.email,
        phone: entity.phone,
        role: 'customer',
        isVerified: false,
        message: 'Registered successfully',
      ),
    );
  }
}

class _FailingRegisterRepository implements RegisterRepository {
  const _FailingRegisterRepository();

  @override
  Future<ApiResult<RegisterResponseEntity>> register(
    RegisterRequestEntity entity,
  ) async {
    return ApiErrorResult(
      failure: Failure(errorMessage: 'Email already exists'),
    );
  }
}
