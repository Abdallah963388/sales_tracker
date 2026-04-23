// ignore_for_file: cascade_invocations

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sit/core/networking/dio_factory.dart';

import 'package:sit/features/intro/onboarding/cubit/onboarding_cubit.dart';
import 'package:sit/features/main_layout/presentation/controllers/cubit/main_layout_cubit.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/home/data/datasourses/service_remote_data_source.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/home/domain/repository/service_repository.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/home/presentation/controllers/service_bloc.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/services/cubit/service_detail_cubit.dart';
import 'package:sit/features/sales_features/admin_home/data/data_source/admin_home_remote_data_source.dart';
import 'package:sit/features/sales_features/admin_home/data/repo/admin_home_repo.dart';
import 'package:sit/features/sales_features/admin_home/presentation/controller/admin_home_cubit.dart';
import 'package:sit/features/sales_features/auth/data/datasourse/auth_remote_datasource.dart';
import 'package:sit/features/sales_features/auth/data/repo/auth_repo.dart';
import 'package:sit/features/sales_features/auth/presentation/controllers/auth_cubit.dart';
import 'package:sit/features/sales_features/clients/data/data_source/clients_remote_data_source.dart';
import 'package:sit/features/sales_features/clients/data/data_source/local_data_source.dart';
import 'package:sit/features/sales_features/clients/data/repo/client_repo.dart';
import 'package:sit/features/sales_features/clients/presentation/controller/client_cubit.dart';
import 'package:sit/features/sales_features/home/data/data_source/rep_home_remote_data_source.dart';
import 'package:sit/features/sales_features/home/data/repo/rep_home_repo.dart';
import 'package:sit/features/sales_features/home/presentation/controller/rep_home_cubit.dart';
import 'package:sit/features/sales_features/main_layout/presentation/controllers/cubit/main_layout_cubit.dart';
import 'package:sit/features/sales_features/my_app/controller/localization_cubit/localization_cubit.dart';
import 'package:sit/features/sales_features/my_app/maintenance/cubit/maintenance_cubit.dart';
import 'package:sit/features/sales_features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:sit/features/sales_features/profile/data/repo/profile_repo.dart';
import 'package:sit/features/sales_features/profile/presentation/controller/profile_cubit.dart';
import 'package:sit/features/sales_features/representative/data/data_source/rep_remote_data_source.dart';
import 'package:sit/features/sales_features/representative/data/repo/rep_repo.dart';
import 'package:sit/features/sales_features/representative/presentation/controller/rep_cubit.dart';
import 'package:sit/features/sales_features/visits/data/data_source/visits_remote_data_source.dart';
import 'package:sit/features/sales_features/visits/data/repo/visits_repo.dart';
import 'package:sit/features/sales_features/visits/presentation/controller/visits_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupGetIt() async {
  getIt
    ..registerLazySingleton<DioFactory>(() {
      return DioFactory();
    })
    ..registerLazySingleton<Dio>(() => getIt<DioFactory>().createDio())
    ..registerLazySingleton<LocalizationCubit>(LocalizationCubit.new)
    ..registerLazySingleton<ServiceRemoteDataSource>(
      () => ServiceRemoteDataSourceImpl(dio: getIt()),
    )
    ..registerLazySingleton<ServiceRepository>(
      () => ServiceRepositoryImpl(remoteDataSource: getIt()),
    )
    ..registerFactory<ServiceDetailCubit>(
      () => ServiceDetailCubit(repository: getIt()),
    )
    ..registerLazySingleton<ServiceBloc>(
      () => ServiceBloc(repository: getIt()),
    )
    // ------------------------------------------------ //
    //               Sales Tracker
    // Local & Remote Data Sources
    ..registerLazySingleton<LocalDataSource>(LocalDataSource.new)
    ..registerLazySingleton<ClientsRemoteDataSource>(
      () => ClientsRemoteDataSource(getIt()),
    )
    ..registerLazySingleton<RepHomeRemoteDataSource>(
      () => RepHomeRemoteDataSource(getIt()),
    )
    ..registerLazySingleton<AuthRemoteDatasourse>(
      () => AuthRemoteDatasourse(getIt()),
    )
    ..registerLazySingleton<VisitsRemoteDataSource>(
      () => VisitsRemoteDataSource(getIt()),
    )
    ..registerLazySingleton<AdminHomeRemoteDataSource>(
      () => AdminHomeRemoteDataSource(getIt()),
    )
    ..registerLazySingleton<RepRemoteDataSource>(
      () => RepRemoteDataSource(getIt()),
    )
    ..registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSource(getIt()),
    )
    // Repositories
    ..registerLazySingleton<ClientRepo>(() => ClientRepo(getIt()))
    ..registerLazySingleton<AuthRepo>(() => AuthRepo(getIt()))
    ..registerLazySingleton<RepHomeRepo>(
      () => RepHomeRepo(getIt()),
    )
    ..registerLazySingleton<VisitsRepo>(
      () => VisitsRepo(getIt()),
    )
    ..registerLazySingleton<AdminHomeRepo>(
      () => AdminHomeRepo(getIt()),
    )
    ..registerLazySingleton<RepRepo>(
      () => RepRepo(getIt()),
    )
    ..registerLazySingleton<ProfileRepo>(
      () => ProfileRepo(getIt()),
    )
    // Cubits
    // ..registerLazySingleton<ClientCubit>(
    //   () => ClientCubit(getIt<LocalDataSource>()),
    // )
    ..registerLazySingleton<MaintenanceCubit>(() => MaintenanceCubit(getIt()))
    ..registerLazySingleton<OnboardingCubit>(OnboardingCubit.new)
    ..registerLazySingleton<SalesMainLayoutCubit>(SalesMainLayoutCubit.new)
    ..registerLazySingleton<MainLayoutCubit>(MainLayoutCubit.new)
    ..registerLazySingleton<LoginCubit>(() => LoginCubit(getIt()))
    ..registerLazySingleton<RepHomeCubit>(() => RepHomeCubit(getIt()))
    ..registerLazySingleton<ClientCubit>(() => ClientCubit(getIt(), getIt()))
    ..registerLazySingleton<VisitsCubit>(() => VisitsCubit(getIt()))
    ..registerLazySingleton<AdminHomeCubit>(() => AdminHomeCubit(getIt()))
    ..registerLazySingleton<RepCubit>(() => RepCubit(getIt()))
    ..registerLazySingleton<ProfileCubit>(() => ProfileCubit(getIt()));
  // Auth Bloc
  // ..registerLazySingleton<AuthBloc>(() => AuthBloc(getIt()));
}
