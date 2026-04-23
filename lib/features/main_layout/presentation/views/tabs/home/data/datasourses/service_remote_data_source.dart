// ignore_for_file: avoid_dynamic_calls, inference_failure_on_function_invocation, only_throw_errors

import 'package:dio/dio.dart';
import 'package:sit/core/networking/failures.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/home/data/models/request_service_model.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/home/data/models/service_model.dart';

abstract class ServiceRemoteDataSource {
  Future<List<Service>> fetchServices();
  Future<Service> fetchServiceDetail(int id);
  Future<String> sendRequestService(RequestServiceModel request);
}

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  ServiceRemoteDataSourceImpl({
    required this.dio,
  });
  final Dio dio;
  static const String apiUrl = 'https://sitapp.sitksa-eg.com/api/services';
  static const String apiUrlContentUs =
      'https://sitapp.sitksa-eg.com/api/contact-us';

  @override
  Future<List<Service>> fetchServices() async {
    final response = await dio.get(apiUrl);

    if (response.statusCode == 200) {
      // فك تشفير JSON
      final data = response.data;
      // الوصول إلى مفتاح 'data' الذي يحتوي على قائمة الخدمات
      final serviceJsonList = data['data'] as List<dynamic>;

      // تحويل قائمة الـ JSON إلى قائمة من كائنات Service
      return serviceJsonList
          .map((json) => Service.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      // إطلاق استثناء في حالة فشل الاتصال
      throw Exception('Failed to load services: ${response.statusCode}');
    }
  }

  @override
  Future<Service> fetchServiceDetail(int id) async {
    // 🚨 الدالة الجديدة
    final response = await dio.get('$apiUrl/$id');

    if (response.statusCode == 200) {
      final data = response.data;
      final serviceJson = data['data']; // الوصول لمفتاح 'data'

      return Service.fromJson(serviceJson as Map<String, dynamic>);
    } else {
      throw Exception(
        'Failed to load service detail for ID $id: ${response.statusCode}',
      );
    }
  }

  @override
  Future<String> sendRequestService(RequestServiceModel request) async {
    try {
      final response = await dio.get(
        apiUrl,
        data: request.toJson(),
      );

      final data = response.data;

      final message = data['message'];
      return message.toString();
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
