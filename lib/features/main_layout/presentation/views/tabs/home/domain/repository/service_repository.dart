import 'package:sit/features/main_layout/presentation/views/tabs/home/data/datasourses/service_remote_data_source.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/home/data/models/request_service_model.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/home/data/models/service_model.dart';

abstract class ServiceRepository {
  Future<List<Service>> getServices();
  Future<Service> getServiceDetail(int id);
  Future<String> sendRequestService(RequestServiceModel request);
}

class ServiceRepositoryImpl implements ServiceRepository {
  ServiceRepositoryImpl({required this.remoteDataSource});
  final ServiceRemoteDataSource remoteDataSource;

  @override
  Future<List<Service>> getServices() async {
    return remoteDataSource.fetchServices();
  }

  @override
  Future<Service> getServiceDetail(int id) async {
    return remoteDataSource.fetchServiceDetail(id);
  }

  @override
  Future<String> sendRequestService(RequestServiceModel request) async {
    return remoteDataSource.sendRequestService(request);
  }
}
