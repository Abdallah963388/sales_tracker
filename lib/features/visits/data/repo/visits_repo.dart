import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sales_tracker/core/networking/failures.dart';
import 'package:sales_tracker/features/visits/data/data_source/visits_remote_data_source.dart';
import 'package:sales_tracker/features/visits/data/model/visits_model.dart';

class VisitsRepo {
  VisitsRepo(this.remoteDataSource);
  final VisitsRemoteDataSource remoteDataSource;

  Future<List<VisitsResponse>> getVisits() {
    return remoteDataSource.getVisits();
  }

  Future<Either<Failure, String>> addVisit({
    required String clientId,
    required String details,
    required String latitude,
    required String longitude,
    required String location,
    String? attachment,
  }) async {
    try {
      final response = await remoteDataSource.addVists(
        clientId: clientId,
        details: details,
        latitude: latitude,
        longitude: longitude,
        location: location,
        attachment: attachment,
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

  Future<Either<Failure, Visit>> getSingleVisit(int visitId) async {
    try {
      final visit = await remoteDataSource.getSingleVisit(visitId);

      if (visit != null) {
        return right(visit);
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

  Future<Either<Failure, String>> deleteVisit(int visitId) async {
    try {
      final response = await remoteDataSource.deleteVisit(visitId);

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

  Future<List<VisitsResponse>> getAllVisits() {
    return remoteDataSource.getAllVisits();
  }

  Future<Either<Failure, String>> adminDeleteVisit(int visitId) async {
    try {
      final response = await remoteDataSource.adminDeleteVisit(visitId);

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

  Future<Either<Failure, List<Visit>>> getClienVisits(int clientId) async {
    try {
      final visits = await remoteDataSource.getClientVisits(clientId);

      if (visits.isNotEmpty) {
        return right(visits);
      } else {
        return left(ServerFailure('لا يوجد زيارات لهذا العميل'));
      }
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> downloadAttachment(String url) async {
    try {
      final path = await remoteDataSource.downloadFile(url);

      return right(path);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
