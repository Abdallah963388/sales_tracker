import 'dart:io';

import 'package:dio/dio.dart';

import '/../core/networking/end_points.dart';

class AuthRemoteDatasourse {
  AuthRemoteDatasourse(this._dioFactory);
  final Dio _dioFactory;

  Future<Response?> login({
    required String? email,
    required String? password,
  }) async {
    return _dioFactory.post(
      EndPoints.login,
      data: {'email': email, 'password': password},
    );
  }

  Future<Response?> register({
    required String? name,
    required String? email,
    required String? password,
    required String? passwordConfirmation,
  }) async {
    return _dioFactory.post(
      EndPoints.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
  }

  Future<Response?> forgotPassword({required String? email}) async {
    return _dioFactory.post(
      EndPoints.sendOtp,
      data: {'email': email},
    );
  }

  Future<Response?> verifyCode({
    required String? code,
    required String? email,
  }) async {
    return _dioFactory.post(
      EndPoints.verifyOtp,
      data: {
        'email': email,
        'otp': code,
      },
    );
  }

  Future<Response?> resetPassword({
    required String? password,
    required String? email,
  }) async {
    return _dioFactory.post(
      EndPoints.updatePassword,
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<Response?> logout() async {
    return _dioFactory.post(EndPoints.logout);
  }

  Future<Response?> getAuthUser() async {
    return _dioFactory.get(EndPoints.getAuthUser);
  }

  Future<Response?> updateProfile({
    required String? name,
    required String? email,
    String? password,
    File? image,
  }) async {
    final data = {
      'name': name,
      'email': email,
      '_method': 'PUT',
    };

    if (password != null && password.isNotEmpty) {
      data['password'] = password;
    }
    return null;
  }
}
