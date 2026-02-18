import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../cache_helper/cache_helper.dart';
import '../cache_helper/cache_values.dart';
import '../constants.dart';
import '../routing/app_routes.dart';

class DioInterceptors {
  DioInterceptors(this.dio);
  final Dio dio;
  InterceptorsWrapper languageInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers['Accept-Language'] = CacheHelper.getLanguage();
        return handler.next(options);
      },
    );
  }

  PrettyDioLogger debugeDioLogger() {
    return PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
      error: true,
      compact: true,
      maxWidth: 90,
    );
  }
}

class RetryInterceptor extends Interceptor {
  RetryInterceptor({required this.dio});
  final Dio dio;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_shouldRetry(err)) {
      const maxRetries = 3;
      const retryDelay = Duration(seconds: 2);

      var retryCount = (err.requestOptions.extra['retryCount'] as int?) ?? 0;

      if (retryCount < maxRetries) {
        retryCount++;
        await Future.delayed(retryDelay);

        final newOptions = Options(
          method: err.requestOptions.method,
          headers: err.requestOptions.headers,
          extra: {...err.requestOptions.extra, 'retryCount': retryCount},
        );

        try {
          final response = await dio.request<dynamic>(
            err.requestOptions.path,
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
            options: newOptions,
          );
          return handler.resolve(response);
        } catch (e) {
          return handler.reject(e as DioException);
        }
      }
    }

    super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (err.type == DioExceptionType.unknown &&
            (err.message?.contains('SocketException') ?? false));
  }
}

class AppErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.requestOptions.extra['skipErrorInterceptor'] == true) {
      return handler.next(err); // مرر الخطأ للكيوبت ليعالجه بنفسه وتوقف هنا
    }
    final context = navigatorKey.currentContext;

    if (err.response?.statusCode == 401) {
      if (context != null) {
        CacheHelper.removeSecured(CacheKeys.userToken);
        GoRouter.of(context).goNamed(AppRoutes.onBoardingScreen);
      }
    } else if (err.response?.statusCode == 503 ||
        err.type == DioExceptionType.unknown ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.unknown ||
        (err.message?.contains('SocketException') ?? false) ||
        err.type == DioExceptionType.badResponse ||
        err.type == DioExceptionType.cancel ||
        err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.badCertificate ||
        err.response?.statusCode == 500) {
      if (context != null) {
        final currentRoute = GoRouterState.of(context).uri.toString();
        if (currentRoute != AppRoutes.maintenanceScreen) {
          GoRouter.of(context).goNamed(AppRoutes.maintenanceScreen);
        }
      }
    }

    super.onError(err, handler);
  }
}

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await CacheHelper.getSecured(CacheKeys.userToken);

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }
}
