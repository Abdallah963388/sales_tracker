import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sales_tracker/core/networking/failures.dart';
import 'package:sales_tracker/features/clients/data/data_source/clients_remote_data_source.dart';
import 'package:sales_tracker/features/clients/data/model/client_model.dart';

class ClientRepo {
  ClientRepo(this.remoteDataSource);
  final ClientsRemoteDataSource remoteDataSource;

  Future<List<ClientsResponse>> getClients() {
    return remoteDataSource.getClients();
  }

  Future<Either<Failure, int>> addClient({
    required String clientName,
    required String businessName,
    required String businessDetails,
    required String region,
    required String location,
    required String latitude,
    required String longitude,
    required String phone,
    required String email,
  }) async {
    try {
      final response = await remoteDataSource.addClient(
        clientName: clientName,
        businessName: businessName,
        businessDetails: businessDetails,
        region: region,
        location: location,
        latitude: latitude,
        longitude: longitude,
        phone: phone,
        email: email,
      );

      if (response?.statusCode == 200 || response?.statusCode == 201) {
        final data = response?.data is Map<String, dynamic>
            ? response?.data as Map<String, dynamic>?
            : null;
        final id = data?['data'] != null && data?['data']['id'] != null
            ? (data!['data']['id'] as int)
            : 0;
        return right(id);
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

  Future<Either<Failure, Client>> getSingleClient(int clientId) async {
    try {
      final client = await remoteDataSource.getSingleClient(clientId);

      if (client != null) {
        return right(client);
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

  Future<Either<Failure, String>> deleteClient(int clientId) async {
    try {
      final response = await remoteDataSource.deleteClient(clientId);

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

  Future<Either<Failure, String>> updateClient({
    required int clientId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await remoteDataSource.updateClient(
        clientId: clientId,
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

  Future<List<ClientsResponse>> getAllClients() {
    return remoteDataSource.getAllClients();
  }
}
