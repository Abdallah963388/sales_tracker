
import 'package:sit/features/visits/data/model/visits_model.dart';

class SingleVisitResponse {
  SingleVisitResponse({this.status, this.message, this.data});

  SingleVisitResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool?;
    message = json['message'] as String?;
    data = json['data'] != null
        ? Visit.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }
  bool? status;
  String? message;
  Visit? data;
}
