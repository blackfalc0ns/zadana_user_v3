import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import '../entities/profile_response_entity.dart';
import '../repo/profile_repository.dart';

/// Profile use case
/// Domain layer - Business logic
@injectable
class ProfileUseCase {
  final ProfileRepository _repository;

  const ProfileUseCase(this._repository);

  Future<ApiResult<ProfileResponseEntity>> call()  {
    return  _repository.getProfile();
  }
}
