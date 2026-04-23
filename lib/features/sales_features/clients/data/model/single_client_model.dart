
import 'package:sit/features/sales_features/clients/data/model/client_model.dart';

class SingleClientResponse {

  SingleClientResponse({this.status, this.message, this.data});

  SingleClientResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool?;
    message = json['message'] as String;
    data = json['data'] != null ? Client.fromJson(json['data'] as Map<String, dynamic>) : null;
  }
  bool? status;
  String? message;
  Client? data;
}
