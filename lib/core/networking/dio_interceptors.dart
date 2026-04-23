import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sit/core/cache_helper/cache_helper.dart';
import 'package:sit/core/cache_helper/cache_values.dart';
import 'package:sit/core/constants.dart';
import 'package:sit/core/routing/app_routes.dart';

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
    // لا نحاول إعادة الطلب إذا هناك response من السيرفر
    if (err.response != null) {
      return super.onError(err, handler);
    }

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
        } catch (e, st) {
          print('⚠️ RetryInterceptor failed: $e');
          print(st);
          if (e is DioException) {
            return handler.reject(e);
          } else {
            return handler.reject(
              DioException(
                requestOptions: err.requestOptions,
                error: e,
                type: DioExceptionType.unknown,
              ),
            );
          }
        }
      }
    }

    super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.unknown ||
        (err.message?.contains('SocketException') ?? false);
  }
}

class AppErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final context = navigatorKey.currentContext;

    // إذا طلب تجاوز المعالجة، مرره مباشرة
    if (err.requestOptions.extra['skipErrorInterceptor'] == true) {
      return handler.next(err);
    }

    // حالة تسجيل خروج
    if (err.response?.statusCode == 401) {
      if (context != null) {
        CacheHelper.removeSecured(CacheKeys.userToken);
        GoRouter.of(context).goNamed(AppRoutes.loginScreen);
      }
    }
    // حالة صيانة أو أخطاء حرجة
    else if (err.response?.statusCode == 503 ||
        err.response?.statusCode == 500 ||
        err.type == DioExceptionType.unknown ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        (err.message?.contains('SocketException') ?? false)) {
      if (context != null) {
        final currentRoute = GoRouterState.of(context).uri.toString();
        if (currentRoute != AppRoutes.maintenanceScreen) {
          GoRouter.of(context).goNamed(AppRoutes.maintenanceScreen);
        }
      }
    }

    // مهم: مرر الخطأ دائمًا للـ Bloc/UI
    handler.next(err);
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
