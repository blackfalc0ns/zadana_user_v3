import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import '../../domain/entities/profile_response_entity.dart';
import '../../domain/entities/update_profile_request_entity.dart';
import '../../domain/repo/profile_repository.dart';
import '../data_source/profile_remote_data_source.dart';
import '../models/update_profile_request_dto.dart';

/// Profile repository implementation
/// Data layer - Repository implementation
@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remoteDataSource);
  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<ProfileResponseEntity>> getProfile() async {
    return safeApiCall(() async {
      final result = await _remoteDataSource.getProfile();
      return result.toEntity();
    });
  }

  @override
  Future<ApiResult<ProfileResponseEntity>> updateProfile(
    UpdateProfileRequestEntity request,
  ) async {
    return safeApiCall(() async {
      final result = await _remoteDataSource.updateProfile(request.toDto());
      return result.toEntity();
    });
  }
}
