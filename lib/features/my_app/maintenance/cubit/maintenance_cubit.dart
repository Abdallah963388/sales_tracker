import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/../core/networking/end_points.dart';

part 'maintenance_state.dart';

class MaintenanceCubit extends Cubit<MaintenanceState> {
  MaintenanceCubit(this.dio) : super(MaintenanceInitial());
  final Dio dio;

  Future<void> checkServerStatus() async {
    emit(MaintenanceLoading());
    try {
      await dio.get<dynamic>(
        EndPoints.getAuthUser,
        options: Options(
          responseType: ResponseType.plain,
          extra: {'skipErrorInterceptor': true},
        ),
      );

      emit(MaintenanceResolved());
    } on DioException catch (e) {
      if (e.response?.statusCode == 503) {
        emit(MaintenanceStillActive('ما زال السيرفر تحت الصيانة'));
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.error.toString().contains('SocketException')) {
        emit(MaintenanceStillActive('تأكد من اتصالك بالإنترنت'));
      } else {
        emit(MaintenanceResolved());
      }
    } catch (e) {
      emit(MaintenanceStillActive(e.toString()));
    }
  }
}
