
import 'package:sit/features/visits/data/model/visits_model.dart';

import 'client_model.dart';

class ClientVisitsModel {

  ClientVisitsModel({this.status, this.message, this.data});

  ClientVisitsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool?;
    message = json['message'] as String?;
    data = json['data'] != null
        ? ClientVisitsData.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }
  bool? status;
  String? message;
  ClientVisitsData? data;
}
class ClientVisitsData {

  ClientVisitsData({this.client, this.visits, this.pagination});

  ClientVisitsData.fromJson(Map<String, dynamic> json) {
    client = json['client'] != null
        ? Client.fromJson(json['client'] as Map<String, dynamic>)
        : null;

    if (json['visits'] != null) {
      visits = (json['visits'] as List)
          .map((e) => Visit.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
        : null;
  }
  Client? client;
  List<Visit>? visits;
  Pagination? pagination;
}
class Pagination {

  Pagination({
    this.total,
    this.perPage,
    this.currentPage,
    this.lastPage,
  });

 Pagination.fromJson(Map<String, dynamic> json) {
    total = (json['total'] as num?)?.toInt();
    perPage = (json['per_page'] as num?)?.toInt();
    currentPage = (json['current_page'] as num?)?.toInt();
    lastPage = (json['last_page'] as num?)?.toInt();
  }
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
}
