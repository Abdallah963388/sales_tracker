import 'package:dio/dio.dart';
import 'package:sales_tracker/core/networking/end_points.dart';
import 'package:sales_tracker/features/clients/data/model/client_model.dart';
import 'package:sales_tracker/features/clients/data/model/single_client_model.dart';

class ClientsRemoteDataSource {
  ClientsRemoteDataSource(this.dio);
  final Dio dio;

  Future<List<ClientsResponse>> getClients() async {
    // ignore: inference_failure_on_function_invocation
    final response = await dio.get(EndPoints.clients);

    final clientsResponse = ClientsResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
    return [clientsResponse];
  }

  Future<Response?> addClient({
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
    final requestData = <String, dynamic>{
      'client_name': clientName,
      'business_name': businessName,
      'business_details': businessDetails,
      'region': region,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
    };

    return dio.post(
      EndPoints.clients,
      data: requestData,
    );
  }

  Future<Client?> getSingleClient(int clientId) async {
    // ignore: inference_failure_on_function_invocation
    final response = await dio.get('${EndPoints.clients}/$clientId');

    final singleClientResponse = SingleClientResponse.fromJson(
      response.data as Map<String, dynamic>,
    );

    return singleClientResponse.data;
  }

  Future<Response?> deleteClient(int clientId) async {
    // ignore: inference_failure_on_function_invocation
    final response = await dio.delete('${EndPoints.clients}/$clientId');
    return response;
  }

  Future<Response?> updateClient({
    required int clientId,
    required Map<String, dynamic> data,
  }) async {
    return dio.put(
      '${EndPoints.clients}/$clientId',
      data: data,
    );
  }

  Future<List<ClientsResponse>> getAllClients() async {
    // ignore: inference_failure_on_function_invocation
    final response = await dio.get(EndPoints.allClients);

    final clientsResponse = ClientsResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
    return [clientsResponse];
  }
}
