import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sit/core/networking/failures.dart';
import 'package:sit/features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:sit/features/profile/data/model/profile_model.dart';


class ProfileRepo {
  ProfileRepo(this.remoteDataSource);

  final ProfileRemoteDataSource remoteDataSource;

  Future<Either<Failure, UserProfileData>> getProfile() async {
    try {
      final profile = await remoteDataSource.getProfile();

      if (profile != null) {
        return right(profile);
      } else {
        return left(ServerFailure('لا توجد بيانات'));
      }
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> updateProfile({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await remoteDataSource.updateProfile(data: data);

      if (response?.statusCode == 200) {
        final resData = response?.data;
        return right(resData?['message'].toString() ?? 'تم التحديث بنجاح');
      } else {
        return left(
          ServerFailure.fromResponse(
            response?.statusCode,
            response?.data['message'],
          ),
        );
      }
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
