
import 'package:sit/features/sales_features/visits/data/model/visits_model.dart';

class AddVisitResponseModel {
  AddVisitResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AddVisitResponseModel.fromJson(Map<String, dynamic> json) {
    return AddVisitResponseModel(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: Visit.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  final bool status;
  final String message;
  final Visit data;

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

// class Visit {
//   Visit({
//     required this.id,
//     required this.clientId,
//     required this.repId,
//     required this.client,
//     required this.latitude,
//     required this.longitude,
//     required this.locationName,
//     required this.details,
//     required this.createdAt,
//     required this.updatedAt,
//     this.attachment,
//   });

//   factory Visit.fromJson(Map<String, dynamic> json) {
//     return Visit(
//       id: json['id'] as int,
//       clientId: json['client_id'].toString(),
//       repId: json['rep_id'] as int,
//       client: ClientInfo.fromJson(json['client'] as Map<String, dynamic>),
//       latitude: (json['latitude'] as num).toDouble(),
//       longitude: (json['longitude'] as num).toDouble(),
//       locationName: json['location_name'] as String,
//       details: json['details'] as String,
//       attachment: json['attachment'] as String?,
//       createdAt: DateTime.parse(json['created_at'] as String),
//       updatedAt: DateTime.parse(json['updated_at'] as String),
//     );
//   }

//   final int id;
//   final String clientId;
//   final int repId;
//   final ClientInfo client;
//   final double latitude;
//   final double longitude;
//   final String locationName;
//   final String details;
//   final String? attachment;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'client_id': clientId,
//       'rep_id': repId,
//       'client': client.toJson(),
//       'latitude': latitude,
//       'longitude': longitude,
//       'location_name': locationName,
//       'details': details,
//       'attachment': attachment,
//       'created_at': createdAt.toIso8601String(),
//       'updated_at': updatedAt.toIso8601String(),
//     };
//   }
// }

// class ClientInfo {
//   ClientInfo({
//     required this.id,
//     required this.clientName,
//     required this.businessName,
//   });

//   factory ClientInfo.fromJson(Map<String, dynamic> json) {
//     return ClientInfo(
//       id: json['id'] as int,
//       clientName: json['client_name'] as String,
//       businessName: json['business_name'] as String,
//     );
//   }

//   final int id;
//   final String clientName;
//   final String businessName;

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'client_name': clientName,
//       'business_name': businessName,
//     };
//   }
// }
