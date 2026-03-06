import 'package:zadana_user_v3/feature/auth/register/domain/entities/register_response_entity.dart';

class RegisterState {
  bool isLoadingRegister;
  String errorMesRegister;
  RegisterResponseEntity? registerResponseEntity;
  RegisterState({
    this.errorMesRegister = '',
    this.isLoadingRegister = false,
    this.registerResponseEntity,
  });
  RegisterState copyWith({
    bool? isLoadingRegister,
    String? errorMesRegister,
    RegisterResponseEntity? registerResponseEntity,
  }) {
    return RegisterState(
      isLoadingRegister: isLoadingRegister ?? this.isLoadingRegister,
      errorMesRegister: errorMesRegister ?? this.errorMesRegister,
      registerResponseEntity:
          registerResponseEntity ?? this.registerResponseEntity,
    );
  }
}
