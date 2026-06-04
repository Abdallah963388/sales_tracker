import 'package:dio/dio.dart';
import 'package:sit/core/networking/end_points.dart';
import 'package:sit/features/representative/data/model/rep_model.dart';
import 'package:sit/features/representative/data/model/single_rep_model.dart';

class RepRemoteDataSource {
  RepRemoteDataSource(this.dio);
  final Dio dio;

  Future<List<RepsResponse>> getReps()async{
    // ignore: inference_failure_on_function_invocation
    final response = await dio.get(EndPoints.reps);
    final repsResponse = RepsResponse.fromJson(
      response.data as Map<String,dynamic>
      
    );
    return [repsResponse];
  }

  Future<Response?> addRep({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    final requestData = <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
    return dio.post(
      EndPoints.reps,
      data: requestData,
    );
  }

  Future<SingleRepData?> getSingleRep(int repId) async {
    // ignore: inference_failure_on_function_invocation
    final response = await dio.get('${EndPoints.reps}/$repId');

    final singleRepResponse = SingleRepModel.fromJson(
      response.data as Map<String, dynamic>,
    );

    return singleRepResponse.data;
  }

   Future<Response?> updateRep({
    required int repId,
    required Map<String, dynamic> data,
  }) async {
    return dio.put(
      '${EndPoints.reps}/$repId',
      data: data,
    );
  }

  Future<Response?> deleteRep(int repId) async {
    // ignore: inference_failure_on_function_invocation
    final response = await dio.delete('${EndPoints.reps}/$repId');
    return response;
  }
}