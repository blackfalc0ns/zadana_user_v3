import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_results.dart';
import '../../domain/entities/profile_response_entity.dart';
import '../../domain/repo/profile_repository.dart';
import '../data_source/profile_remote_data_source.dart';

/// Profile repository implementation
/// Data layer - Repository implementation
@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  const ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<ProfileResponseEntity>> getProfile() async {
    return safeApiCall(() async {
      final result = await _remoteDataSource.getProfile();
      return result.toEntity();
    });
  }
}
