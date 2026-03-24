import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sales_tracker/core/networking/end_points.dart';
import 'package:sales_tracker/features/clients/data/model/client_visits_model.dart';
import 'package:sales_tracker/features/visits/data/model/single_visit_model.dart';
import 'package:sales_tracker/features/visits/data/model/visits_model.dart';

class VisitsRemoteDataSource {
  VisitsRemoteDataSource(this.dio);
  final Dio dio;

  Future<List<VisitsResponse>> getVisits() async {
    // ignore: inference_failure_on_function_invocation
    final response = await dio.get(EndPoints.visits);
    final visitsResponse = VisitsResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
    return [visitsResponse];
  }

  Future<Response?> addVists({
    required String clientId,
    required String details,
    required String latitude,
    required String longitude,
    required String location,
    String? attachment,
  }) async {
    final formData = FormData.fromMap({
      'client_id': clientId,
      'details': details,
      'latitude': latitude,
      'longitude': longitude,
      'location_name': location,

      if (attachment != null && attachment.isNotEmpty)
        'attachment': await MultipartFile.fromFile(
          attachment,
          filename: attachment.split('/').last,
        ),
    });

    return dio.post(
      EndPoints.visits,
      data: formData,
    );
  }

  Future<Visit?> getSingleVisit(int visitId) async {
    // ignore: inference_failure_on_function_invocation
    final response = await dio.get(
      '${EndPoints.visits}/$visitId',
    );

    final singleVisitResponse = SingleVisitResponse.fromJson(
      response.data as Map<String, dynamic>,
    );

    return singleVisitResponse.data;
  }

  Future<Response?> deleteVisit(int visitId) async {
    // ignore: inference_failure_on_function_invocation
    final response = await dio.delete('${EndPoints.visits}/$visitId');
    return response;
  }

  Future<List<VisitsResponse>> getAllVisits() async {
    // ignore: inference_failure_on_function_invocation
    final response = await dio.get(EndPoints.allVisits);
    final visitsResponse = VisitsResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
    return [visitsResponse];
  }

  Future<Response?> adminDeleteVisit(int visitId) async {
    // ignore: inference_failure_on_function_invocation
    final response = await dio.delete('${EndPoints.allVisits}/$visitId');
    return response;
  }

  Future<List<Visit>> getClientVisits(int clientId) async {
    // ignore: inference_failure_on_function_invocation
    final response = await dio.get('${EndPoints.clients}/$clientId/visits');

    final clientVisitsResponse = ClientVisitsModel.fromJson(
      response.data as Map<String, dynamic>,
    );

    return clientVisitsResponse.data?.visits ?? [];
  }

  Future<String> downloadFile(String url) async {
    try {
      if (Platform.isAndroid) {
        final sdkInt = (await DeviceInfoPlugin().androidInfo).version.sdkInt;
        if (sdkInt >= 33) {
          // Android 13+
          final statusImages = await Permission.photos.request();
          final statusVideos = await Permission.videos.request();
          final statusAudio = await Permission.audio.request();
          if (statusImages.isGranted &&
              statusVideos.isGranted &&
              statusAudio.isGranted) {
            // Permissions granted, proceed
          } else {
            throw Exception('Required permissions not granted');
          }
        } else if (sdkInt >= 30) {
          // Android 11+
          final status = await Permission.manageExternalStorage.request();
          if (!status.isGranted) {
            throw Exception('Manage external storage permission not granted');
          }
        } else {
          // Android <= 10
          final status = await Permission.storage.request();
          if (!status.isGranted) {
            throw Exception('Storage permission not granted');
          }
        }

        // return true; // iOS
      }

      final fileName = url.split('/').last;

      Directory? directory;

      if (Platform.isAndroid) {
        // مجلد Downloads العام
        directory = Directory('/storage/emulated/0/Download');
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }
      } else {
        // iOS أو App-specific
        directory = await getApplicationDocumentsDirectory();
      }

      final filePath = '${directory.path}/$fileName';

      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print(
              'Downloading: ${(received / total * 100).toStringAsFixed(0)}%',
            );
          }
        },
      );

      print('File saved at $filePath');

      // // فتح الملف مباشرة بعد التحميل
      // await OpenFilex.open(filePath);

      return filePath;
    } catch (e) {
      print('Error downloading file: $e');
      throw Exception('Error downloading file: $e');
    }
  }
}
