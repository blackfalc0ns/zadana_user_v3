import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/entities/register_entity.dart';
import 'package:zadana_user_v3/feature/auth/register/domain/usecase/register_usecase.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_event.dart';
import 'package:zadana_user_v3/feature/auth/register/presentation/manager/register_state.dart';

@injectable
class RegisterViewMode extends Cubit<RegisterState> {
  RegisterViewMode(this._registerUseCase) : super(RegisterState());
  final RegisterUseCase _registerUseCase;
  void doIntent(RegisterEvent event) {}

  void register(RegisterEntity requestEntity) async {
    emit(state.copyWith(isLoadingRegister: true));
    var result = await _registerUseCase.call(requestEntity);
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoadingRegister: false,
            registerResponseEntity: result.data,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoadingRegister: false,
            errorMesRegister: result.failure.toString(),
          ),
        );
    }
  }
}
