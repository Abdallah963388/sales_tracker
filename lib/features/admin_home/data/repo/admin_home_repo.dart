import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sit/core/networking/failures.dart';
import 'package:sit/features/admin_home/data/data_source/admin_home_remote_data_source.dart';
import 'package:sit/features/admin_home/data/model/admin_home_model.dart';


class AdminHomeRepo {
  AdminHomeRepo(this._remoteDataSource);
  final AdminHomeRemoteDataSource _remoteDataSource;

  Future<Either<Failure, AdminHomeModel>> getAdminDashboard() async {
    try {
      final response = await _remoteDataSource.getAdminDashboard();
      if (response != null && response.statusCode == 200) {
        final dashboard = AdminHomeModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        return right(dashboard);
      } else {
        return left(
          ServerFailure.fromResponse(
            response?.statusCode,
            response?.data,
          ),
        );
      }
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}