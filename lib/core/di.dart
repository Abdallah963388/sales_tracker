import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sales_tracker/features/clients/data/data_source/remote_data_source.dart';
import 'package:sales_tracker/features/clients/data/repo/client_repo.dart';
import 'package:sales_tracker/features/clients/presentation/controller/client_cubit.dart';

import '../core/networking/dio_factory.dart';
import '../features/auth/data/datasourse/auth_remote_datasource.dart';
import '../features/auth/data/repo/auth_repo.dart';
import '../features/auth/presentation/controllers/bloc/auth_bloc.dart';
import '../features/intro/onboarding/cubit/onboarding_cubit.dart';
import '../features/main_layout/presentation/controllers/cubit/main_layout_cubit.dart';
import '../features/my_app/controller/localization_cubit/localization_cubit.dart';
import '../features/my_app/maintenance/cubit/maintenance_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupGetIt() async {
  getIt
    ..registerLazySingleton<DioFactory>(() {
      return DioFactory();
    })
    ..registerLazySingleton<Dio>(() => getIt<DioFactory>().createDio())
    ..registerFactory<MaintenanceCubit>(() => MaintenanceCubit(getIt()))
    ..registerLazySingleton<LocalizationCubit>(LocalizationCubit.new)
    ..registerLazySingleton<OnboardingCubit>(OnboardingCubit.new)
    ..registerLazySingleton<MainLayoutCubit>(MainLayoutCubit.new)
    /// ------------------ < Auth Module > ------------------
    ..registerLazySingleton<AuthRemoteDatasourse>(
      () => AuthRemoteDatasourse(getIt()),
    )
    ..registerLazySingleton<AuthRepo>(() => AuthRepo(getIt()))
    ..registerLazySingleton<AuthBloc>(() => AuthBloc(getIt()))
    ..registerLazySingleton<ClientRepo>(() => ClientRepo(getIt()))
    ..registerLazySingleton<ClientCubit>(() => ClientCubit(getIt()))
    ..registerLazySingleton<RemoteDataSource>(() => RemoteDataSource(getIt()));
}
