import 'package:dio/dio.dart';
import 'package:sit/core/networking/end_points.dart';
import 'package:sit/features/sales_features/profile/data/model/profile_model.dart';


class ProfileRemoteDataSource {
  ProfileRemoteDataSource(this.dio);
  final Dio dio;

  Future<UserProfileData?> getProfile() async {
    // ignore: inference_failure_on_function_invocation
    final response = await dio.get(EndPoints.profile);

    final profileResponse = UserProfile.fromJson(
      response.data as Map<String, dynamic>,
    );

    return profileResponse.data;
  }

  Future<Response?> updateProfile({
    required Map<String, dynamic> data,
  }) async {
    return dio.post(
      EndPoints.editProfile,
      data: data,
    );
  }
}
