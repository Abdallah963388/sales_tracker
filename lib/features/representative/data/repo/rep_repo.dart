import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sales_tracker/core/networking/failures.dart';
import 'package:sales_tracker/features/representative/data/data_source/rep_remote_data_source.dart';
import 'package:sales_tracker/features/representative/data/model/rep_model.dart';
import 'package:sales_tracker/features/representative/data/model/single_rep_model.dart';

class RepRepo {
  RepRepo(this._remoteDataSource);
  final RepRemoteDataSource _remoteDataSource;

  Future<List<RepsResponse>> getReps(){
    return _remoteDataSource.getReps();
 }

 Future<Either<Failure, String>> addRep({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _remoteDataSource.addRep(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        final data = response?.data;
        return right((data?['message'] as String?) ?? '');
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

  Future<Either<Failure, SingleRepData>> getSingleRep(int repId) async {
    try {
      final rep = await _remoteDataSource.getSingleRep(repId);

      if (rep != null) {
        return right(rep);
      } else {
        return left(ServerFailure('لا يوجد بيانات'));
      }
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> deleteRep(int repId) async {
    try {
      final response = await _remoteDataSource.deleteRep(repId);

      if (response?.statusCode == 200) {
        final data = response?.data;
        return right(data?['message'].toString() ?? 'تم الحذف بنجاح');
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

  Future<Either<Failure, String>> updateRep({
    required int repId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _remoteDataSource.updateRep(
        repId: repId,
        data: data,
      );

      if (response?.statusCode == 200) {
        final data = response?.data;
        return right(data?['message'].toString() ?? 'تم التعديل بنجاح');
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