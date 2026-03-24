import 'package:dio/dio.dart';
import '/core/networking/end_points.dart';

class RepHomeRemoteDataSource {
  RepHomeRemoteDataSource(this._dio);
  final Dio _dio;

  Future<Response?> getDashboard() async {
    return _dio.get(EndPoints.repHome);
  }
}
