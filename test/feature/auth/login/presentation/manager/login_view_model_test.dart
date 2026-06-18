import 'package:flutter_test/flutter_test.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/auth/login/domain/entities/login_request_entity.dart';
import 'package:zadana_user_v3/feature/auth/login/domain/entities/login_response_entity.dart';
import 'package:zadana_user_v3/feature/auth/login/domain/entities/tokens_entity.dart';
import 'package:zadana_user_v3/feature/auth/login/domain/entities/user_entity.dart';
import 'package:zadana_user_v3/feature/auth/login/domain/repo/login_repository.dart';
import 'package:zadana_user_v3/feature/auth/login/domain/usecase/login_usecase.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/manager/login_event.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/manager/login_state.dart';
import 'package:zadana_user_v3/feature/auth/login/presentation/manager/login_view_model.dart';

void main() {
  group('LoginViewModel', () {
    test('emits loading then success when login succeeds', () async {
      final viewModel = LoginViewModel(
        const LoginUseCase(_SuccessfulLoginRepository()),
      );

      final expectation = expectLater(
        viewModel.stream,
        emitsInOrder([
          predicate<LoginState>(
            (state) => state.isLoading == true && state.isSuccess == false,
          ),
          predicate<LoginState>(
            (state) =>
                state.isLoading == false &&
                state.isSuccess == true &&
                state.loginResponse != null,
          ),
        ]),
      );

      viewModel.doIntent(
        LoginSubmitEvent(
          requestEntity: const LoginRequestEntity(
            identifier: 'test@example.com',
            password: 'Password123',
          ),
        ),
      );

      await expectation;
      await viewModel.close();
    });

    test('emits loading then error when login fails', () async {
      final viewModel = LoginViewModel(
        const LoginUseCase(_FailingLoginRepository()),
      );

      final expectation = expectLater(
        viewModel.stream,
        emitsInOrder([
          predicate<LoginState>(
            (state) => state.isLoading == true && state.errorMessage == null,
          ),
          predicate<LoginState>(
            (state) =>
                state.isLoading == false &&
                state.isSuccess == false &&
                state.errorMessage == 'Invalid credentials',
          ),
        ]),
      );

      viewModel.doIntent(
        LoginSubmitEvent(
          requestEntity: const LoginRequestEntity(
            identifier: 'test@example.com',
            password: 'wrong-password',
          ),
        ),
      );

      await expectation;
      await viewModel.close();
    });
  });
}

class _SuccessfulLoginRepository implements LoginRepository {
  const _SuccessfulLoginRepository();

  @override
  Future<ApiResult<LoginResponseEntity>> login(
    LoginRequestEntity request,
  ) async {
    return ApiSuccessResult(
      data: const LoginResponseEntity(
        tokens: TokensEntity(
          accessToken: 'access-token',
          refreshToken: 'refresh-token',
        ),
        user: UserEntity(
          id: '1',
          fullName: 'Test User',
          email: 'test@example.com',
          phone: '01000000000',
          role: 'customer',
        ),
      ),
    );
  }
}

class _FailingLoginRepository implements LoginRepository {
  const _FailingLoginRepository();

  @override
  Future<ApiResult<LoginResponseEntity>> login(
    LoginRequestEntity request,
  ) async {
    return ApiErrorResult(
      failure: Failure(errorMessage: 'Invalid credentials'),
    );
  }
}
