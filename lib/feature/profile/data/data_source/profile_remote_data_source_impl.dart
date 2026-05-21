import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import '../models/profile_response_model_dto.dart';
import '../models/update_profile_photo_request_dto.dart';
import '../models/update_profile_request_dto.dart';
import 'profile_remote_data_source.dart';

/// Profile remote data source implementation
/// Data layer - API implementation using Retrofit
@Injectable(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(this._apiServices);
  final ApiServices _apiServices;

  @override
  Future<ProfileResponseModelDto> getProfile() {
    return _apiServices.getProfile();
  }

  @override
  Future<ProfileResponseModelDto> updateProfile(
    UpdateProfileRequestDto request,
  ) {
    return _apiServices.updateProfile(request);
  }

  @override
  Future<ProfileResponseModelDto> updateProfilePhoto(
    String profilePhotoUrl,
  ) {
    return _apiServices.updateProfilePhoto(
      UpdateProfilePhotoRequestDto(profilePhotoUrl: profilePhotoUrl),
    );
  }

  @override
  Future<void> deleteProfilePhoto() {
    return _apiServices.deleteProfilePhoto();
  }

  @override
  Future<String> uploadFile(String filePath) async {
    final file = await MultipartFile.fromFile(filePath);
    final response = await _apiServices.uploadFile(
      file,
      'uploads/users/profile',
    );
    return response.url;
  }
}
