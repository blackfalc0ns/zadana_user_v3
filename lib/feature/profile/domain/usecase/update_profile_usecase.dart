import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import 'package:zadana_user_v3/feature/profile/domain/entities/profile_response_entity.dart';
import 'package:zadana_user_v3/feature/profile/domain/entities/update_profile_request_entity.dart';
import 'package:zadana_user_v3/feature/profile/domain/repo/profile_repository.dart';

@injectable
class UpdateProfileUseCase {
  const UpdateProfileUseCase(this._repository);
  final ProfileRepository _repository;

  Future<ApiResult<ProfileResponseEntity>> call(
    UpdateProfileRequestEntity request,
  ) {
    return _repository.updateProfile(request);
  }
}
