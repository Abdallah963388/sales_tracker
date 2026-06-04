import 'package:dio/dio.dart';
import 'package:sit/core/networking/end_points.dart';
// import 'package:sales_tracker/core/networking/end_points.dart';

class AdminHomeRemoteDataSource {
  AdminHomeRemoteDataSource(this.dio);
  final Dio dio;

  Future<Response?> getAdminDashboard()async{
    return dio.get(EndPoints.adminHome);

  }
}