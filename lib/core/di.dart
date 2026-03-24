import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sales_tracker/features/admin_home/data/data_source/admin_home_remote_data_source.dart';
import 'package:sales_tracker/features/admin_home/data/repo/admin_home_repo.dart';
import 'package:sales_tracker/features/admin_home/presentation/controller/admin_home_cubit.dart';
import 'package:sales_tracker/features/auth/presentation/controllers/auth_cubit.dart';
import 'package:sales_tracker/features/clients/data/data_source/clients_remote_data_source.dart';
import 'package:sales_tracker/features/clients/data/data_source/local_data_source.dart';
import 'package:sales_tracker/features/clients/data/repo/client_repo.dart';
import 'package:sales_tracker/features/clients/presentation/controller/client_cubit.dart';
import 'package:sales_tracker/features/home/data/data_source/rep_home_remote_data_source.dart';
import 'package:sales_tracker/features/home/data/repo/rep_home_repo.dart';
import 'package:sales_tracker/features/home/presentation/controller/rep_home_cubit.dart';
import 'package:sales_tracker/features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:sales_tracker/features/profile/data/repo/profile_repo.dart';
import 'package:sales_tracker/features/profile/presentation/controller/profile_cubit.dart';
import 'package:sales_tracker/features/representative/data/data_source/rep_remote_data_source.dart';
import 'package:sales_tracker/features/representative/data/repo/rep_repo.dart';
import 'package:sales_tracker/features/representative/presentation/controller/rep_cubit.dart';
import 'package:sales_tracker/features/visits/data/data_source/visits_remote_data_source.dart';
import 'package:sales_tracker/features/visits/data/repo/visits_repo.dart';
import 'package:sales_tracker/features/visits/presentation/controller/visits_cubit.dart';

import '../core/networking/dio_factory.dart';
import '../features/auth/data/datasourse/auth_remote_datasource.dart';
import '../features/auth/data/repo/auth_repo.dart';
import '../features/intro/onboarding/cubit/onboarding_cubit.dart';
import '../features/main_layout/presentation/controllers/cubit/main_layout_cubit.dart';
import '../features/my_app/controller/localization_cubit/localization_cubit.dart';
import '../features/my_app/maintenance/cubit/maintenance_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupGetIt() async {
  getIt
    // Dio & DioFactory
    ..registerLazySingleton<DioFactory>(DioFactory.new)
    ..registerLazySingleton<Dio>(() => getIt<DioFactory>().createDio())
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
    ..registerLazySingleton<LocalizationCubit>(LocalizationCubit.new)
    ..registerLazySingleton<OnboardingCubit>(OnboardingCubit.new)
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
