import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '/../core/cache_helper/cache_helper.dart';
import '/../core/cache_helper/cache_values.dart';
import '/../core/networking/failures.dart';
import '/../features/auth/data/datasourse/auth_remote_datasource.dart';
import '/../features/auth/data/model/user_model.dart';

class AuthRepo {
  AuthRepo(this._remoteDataSource);
  final AuthRemoteDatasourse _remoteDataSource;

  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      if (response != null && response.statusCode == 200) {
        final userModel = UserModel.fromJson(
          response.data as Map<String, dynamic>,
        );

        await _saveUserData(userModel);

        return right(userModel);
      } else {
        return left(
          ServerFailure.fromResponse(
            response?.statusCode,
            response?.data,
          ),
        );
      }
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await _remoteDataSource.register(
        name: fullName,
        email: email,
        password: password,
        passwordConfirmation: confirmPassword,
      );

      if (response != null && response.statusCode == 200) {
        final userModel = UserModel.fromJson(
          response.data as Map<String, dynamic>,
        );

        await _saveUserData(userModel);

        return right(userModel);
      } else {
        return left(
          ServerFailure.fromResponse(
            response?.statusCode,
            response?.data,
          ),
        );
      }
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String?>> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await _remoteDataSource.forgotPassword(email: email);

      if (response != null && response.statusCode == 200) {
        final code = response.data['data']?.toString();
        return right(code);
      } else {
        return left(
          ServerFailure.fromResponse(
            response?.statusCode,
            response?.data,
          ),
        );
      }
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> verifyCode({
    required String code,
    required String email,
  }) async {
    try {
      final response = await _remoteDataSource.verifyCode(
        code: code,
        email: email,
      );

      if (response != null && response.statusCode == 200) {
        return right(true);
      } else {
        return left(
          ServerFailure.fromResponse(
            response?.statusCode,
            response?.data,
          ),
        );
      }
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> resetPassword({
    required String password,
    required String confirmPassword,
    required String email,
  }) async {
    try {
      final response = await _remoteDataSource.resetPassword(
        password: password,
        email: email,
      );

      if (response != null && response.statusCode == 200) {
        return right(true);
      } else {
        return left(
          ServerFailure.fromResponse(
            response?.statusCode,
            response?.data,
          ),
        );
      }
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> logout() async {
    try {
      final response = await _remoteDataSource.logout();

      if (response != null && response.statusCode == 200) {
        await _clearUserData();
        return right(true);
      } else {
        return left(
          ServerFailure.fromResponse(
            response?.statusCode,
            response?.data,
          ),
        );
      }
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  Future<void> _saveUserData(UserModel userModel) async {
    if (userModel.data?.token != null) {
      await CacheHelper.setSecured(
        CacheKeys.userToken,
        userModel.data!.token!,
      );
    }
    if (userModel.data?.user?.id != null) {
      await CacheHelper.set(
        CacheKeys.userId,
        userModel.data!.user!.id,
      );
    }
  }

  Future<void> _clearUserData() async {
    await CacheHelper.clearSecured();
    await CacheHelper.remove(CacheKeys.userId);
  }
}
