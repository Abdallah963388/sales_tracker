import 'package:sales_tracker/features/clients/data/model/client_model.dart';

class VisitsResponse {
  VisitsResponse({this.status, this.message, this.data});

  VisitsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool?;
    message = json['message'] as String?;
    data = json['data'] != null
        ? VisitsData.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }

  bool? status;
  String? message;
  VisitsData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class VisitsData {
  VisitsData({this.visits, this.pagination});

  VisitsData.fromJson(Map<String, dynamic> json) {
    if (json['visits'] != null) {
      visits = List<Visit>.from(
        (json['visits'] as List).map(
          (x) => Visit.fromJson(x as Map<String, dynamic>),
        ),
      );
    } else {
      visits = [];
    }

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
        : null;
  }

  List<Visit>? visits;
  Pagination? pagination;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['visits'] = visits?.map((x) => x.toJson()).toList();
    if (pagination != null) {
      map['pagination'] = pagination!.toJson();
    }
    return map;
  }
}

class Visit {
  Visit({
    this.id,
    this.clientId,
    this.repId,
    this.client,
    this.latitude,
    this.longitude,
    this.locationName,
    this.details,
    this.attachment,
    this.createdAt,
    this.updatedAt,
  });

  Visit.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    clientId = json['client_id'] as int?;
    repId = json['rep_id'] as int?;
    client = json['client'] != null
        ? Client.fromJson(json['client'] as Map<String, dynamic>)
        : null;
    latitude = (json['latitude'] as num?)?.toDouble();
    longitude = (json['longitude'] as num?)?.toDouble();
    locationName = json['location_name'] as String?;
    details = json['details'] as String?;
    attachment = (json['attachment'] != null)
        ? (json['attachment']['url'] as String?)
        : '';
    createdAt = json['created_at'] as String?;
    updatedAt = json['updated_at'] as String?;
  }

  int? id;
  int? clientId;
  int? repId;
  Client? client;
  double? latitude;
  double? longitude;
  String? locationName;
  String? details;
  String? attachment;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['client_id'] = clientId;
    map['rep_id'] = repId;
    if (client != null) {
      map['client'] = client!.toJson();
    }
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['location_name'] = locationName;
    map['details'] = details;
    map['attachment'] = attachment;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}

// class ClientSummary {
//   ClientSummary({
//     this.id,
//     this.clientName,
//     this.businessName,
//     this.region,
//   });

//   ClientSummary.fromJson(Map<String, dynamic> json) {
//     id = json['id'] as int?;
//     clientName = json['client_name'] as String?;
//     businessName = json['business_name'] as String?;
//     region = json['region'] as String?;
//   }

//   int? id;
//   String? clientName;
//   String? businessName;
//   String? region;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['client_name'] = clientName;
//     map['business_name'] = businessName;
//     map['region'] = region;
//     return map;
//   }
// }

class Pagination {
  Pagination({this.total, this.perPage, this.currentPage, this.lastPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'] as int?;
    perPage = json['per_page'] as int?;
    currentPage = json['current_page'] as int?;
    lastPage = json['last_page'] as int?;
  }

  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = total;
    map['per_page'] = perPage;
    map['current_page'] = currentPage;
    map['last_page'] = lastPage;
    return map;
  }
}
