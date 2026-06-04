import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sit/features/home/data/data_source/rep_home_remote_data_source.dart';
import 'package:sit/features/home/data/model/rep_home_model.dart';

import '/core/networking/failures.dart';


class RepHomeRepo {
  RepHomeRepo(this._remoteDataSource);
  final RepHomeRemoteDataSource _remoteDataSource;

  Future<Either<Failure, RepHomeModel>> getDashboard() async {
    try {
      final response = await _remoteDataSource.getDashboard();
      if (response != null && response.statusCode == 200) {
        final dashboard = RepHomeModel.fromJson(
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
