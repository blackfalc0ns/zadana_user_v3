import 'package:zadana_user_v3/feature/auth/register/domain/entities/register_entity.dart';

sealed class RegisterEvent {}

class SumbitRegister extends RegisterEvent {
  RegisterEntity registerEntity;
  SumbitRegister({required this.registerEntity});
}
