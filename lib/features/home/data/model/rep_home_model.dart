

import 'package:sit/features/clients/data/model/client_model.dart';
import 'package:sit/features/visits/data/model/visits_model.dart';

class RepHomeModel {
  RepHomeModel({this.status, this.message, this.data});

  RepHomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool?;
    message = json['message'] as String?;
    data = json['data'] != null
        ? RepHomeData.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }

  bool? status;
  String? message;
  RepHomeData? data;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class RepHomeData {
  RepHomeData({this.stats, this.recentClients, this.recentVisits});

  RepHomeData.fromJson(Map<String, dynamic> json) {
    stats = json['stats'] != null
        ? StatsModel.fromJson(json['stats'] as Map<String, dynamic>)
        : null;

    if (json['recent_clients'] != null) {
      recentClients = List<Client>.from(
        (json['recent_clients'] as List).map(
          (x) => Client.fromJson(x as Map<String, dynamic>),
        ),
      );
    } else {
      recentClients = [];
    }

    if (json['recent_visits'] != null) {
      recentVisits = List<Visit>.from(
        (json['recent_visits'] as List).map(
          (x) => Visit.fromJson(x as Map<String, dynamic>),
        ),
      );
    } else {
      recentVisits = [];
    }
  }

  StatsModel? stats;
  List<Client>? recentClients;
  List<Visit>? recentVisits;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (stats != null) {
      data['stats'] = stats!.toJson();
    }

    data['recent_clients'] = recentClients?.map((x) => x.toJson()).toList();
    data['recent_visits'] = recentVisits?.map((x) => x.toJson()).toList();

    return data;
  }
}

class StatsModel {
  StatsModel({this.totalVisits, this.totalClients});

  StatsModel.fromJson(Map<String, dynamic> json) {
    totalVisits = json['total_visits'] as int?;
    totalClients = json['total_clients'] as int?;
  }

  int? totalVisits;
  int? totalClients;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['total_visits'] = totalVisits;
    data['total_clients'] = totalClients;
    return data;
  }
}

// class RecentClient {
//   RecentClient({
//     this.id,
//     this.clientName,
//     this.businessName,
//     this.region,
//     this.phone,
//     this.visitsCount,
//     this.lastVisitAt,
//     this.updatedAt,
//   });

//   RecentClient.fromJson(Map<String, dynamic> json) {
//     id = json['id'] as int?;
//     clientName = json['client_name'] as String?;
//     businessName = json['business_name'] as String?;
//     region = json['region'] as String?;
//     phone = json['phone'] as String?;
//     visitsCount = json['visits_count'] as int?;
//     lastVisitAt = json['last_visit_at'] as String?;
//     updatedAt = json['updated_at'] as String?;
//   }

//   int? id;
//   String? clientName;
//   String? businessName;
//   String? region;
//   String? phone;
//   int? visitsCount;
//   String? lastVisitAt;
//   String? updatedAt;

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['id'] = id;
//     data['client_name'] = clientName;
//     data['business_name'] = businessName;
//     data['region'] = region;
//     data['phone'] = phone;
//     data['visits_count'] = visitsCount;
//     data['last_visit_at'] = lastVisitAt;
//     data['updated_at'] = updatedAt;
//     return data;
//   }
// }

// class RecentVisit {
//   RecentVisit({
//     this.id,
//     this.client,
//     this.locationName,
//     this.details,
//     this.hasAttachment,
//     this.createdAt,
//   });

//   RecentVisit.fromJson(Map<String, dynamic> json) {
//     id = json['id'] as int?;
//     client = json['client'] != null
//         ? VisitClient.fromJson(json['client'] as Map<String, dynamic>)
//         : null;
//     locationName = json['location_name'] as String?;
//     details = json['details'] as String?;
//     hasAttachment = json['has_attachment'] as bool?;
//     createdAt = json['created_at'] as String?;
//   }

//   int? id;
//   VisitClient? client;
//   String? locationName;
//   String? details;
//   bool? hasAttachment;
//   String? createdAt;

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['id'] = id;
//     if (client != null) {
//       data['client'] = client!.toJson();
//     }
//     data['location_name'] = locationName;
//     data['details'] = details;
//     data['has_attachment'] = hasAttachment;
//     data['created_at'] = createdAt;
//     return data;
//   }
// }

class VisitClient {
  VisitClient({this.id, this.clientName, this.businessName, this.region});

  VisitClient.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    clientName = json['client_name'] as String?;
    businessName = json['business_name'] as String?;
    region = json['region'] as String?;
  }

  int? id;
  String? clientName;
  String? businessName;
  String? region;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['client_name'] = clientName;
    data['business_name'] = businessName;
    data['region'] = region;
    return data;
  }
}
