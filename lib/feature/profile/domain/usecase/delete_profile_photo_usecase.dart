import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import '../repo/profile_repository.dart';

/// Delete profile photo use case
/// Domain layer - Business logic
@injectable
class DeleteProfilePhotoUseCase {
  const DeleteProfilePhotoUseCase(this._repository);
  final ProfileRepository _repository;

  Future<ApiResult<void>> call() {
    return _repository.deleteProfilePhoto();
  }
}
