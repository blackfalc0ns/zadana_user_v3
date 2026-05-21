import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import '../entities/profile_response_entity.dart';
import '../repo/profile_repository.dart';

/// Update profile photo use case
/// Domain layer - Business logic
@injectable
class UpdateProfilePhotoUseCase {
  const UpdateProfilePhotoUseCase(this._repository);
  final ProfileRepository _repository;

  Future<ApiResult<ProfileResponseEntity>> call(String filePath) {
    return _repository.updateProfilePhoto(filePath);
  }
}
