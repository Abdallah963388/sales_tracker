
import 'package:sit/features/sales_features/clients/data/model/client_model.dart';

class AdminHomeModel {
  AdminHomeModel({this.status, this.message, this.data});

  AdminHomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool?;
    message = json['message'] as String?;
    data = json['data'] != null
        ? AdminHomeData.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }

  bool? status;
  String? message;
  AdminHomeData? data;

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

class AdminHomeData {
  AdminHomeData({this.stats, this.recentReps, this.recentClients});

  AdminHomeData.fromJson(Map<String, dynamic> json) {
    stats = json['stats'] != null
        ? StatsModel.fromJson(json['stats'] as Map<String, dynamic>)
        : null;

    if (json['recent_reps'] != null) {
      recentReps = (json['recent_reps'] as List)
          .map((e) => RecentRep.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      recentReps = [];
    }

    if (json['recent_clients'] != null) {
      recentClients = (json['recent_clients'] as List)
          .map((e) => Client.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      recentClients = [];
    }
  }

  StatsModel? stats;
  List<RecentRep>? recentReps;
  List<Client>? recentClients;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (stats != null) map['stats'] = stats!.toJson();
    map['recent_reps'] = recentReps?.map((e) => e.toJson()).toList();
    map['recent_clients'] = recentClients?.map((e) => e.toJson()).toList();
    return map;
  }
}

class StatsModel {
  StatsModel({
    this.todayVisits,
    this.todayClients,
    this.totalReps,
    this.totalClients,
    this.totalVisits,
  });

  StatsModel.fromJson(Map<String, dynamic> json) {
    todayVisits = json['today_visits'] as int?;
    todayClients = json['today_clients'] as int?;
    totalReps = json['total_reps'] as int?;
    totalClients = json['total_clients'] as int?;
    totalVisits = json['total_visits'] as int?;
  }

  int? todayVisits;
  int? todayClients;
  int? totalReps;
  int? totalClients;
  int? totalVisits;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['today_visits'] = todayVisits;
    map['today_clients'] = todayClients;
    map['total_reps'] = totalReps;
    map['total_clients'] = totalClients;
    map['total_visits'] = totalVisits;
    return map;
  }
}

class RecentRep {
  RecentRep({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.isActive,
    this.clientsCount,
    this.visitsCount,
    this.updatedAt,
  });

  RecentRep.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    email = json['email'] as String?;
    phone = json['phone'] as String?;
    isActive = json['is_active'] as bool?;
    clientsCount = json['clients_count'] as int?;
    visitsCount = json['visits_count'] as int?;
    updatedAt = json['updated_at'] as String?;
  }

  int? id;
  String? name;
  String? email;
  String? phone;
  bool? isActive;
  int? clientsCount;
  int? visitsCount;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['phone'] = phone;
    map['is_active'] = isActive;
    map['clients_count'] = clientsCount;
    map['visits_count'] = visitsCount;
    map['updated_at'] = updatedAt;
    return map;
  }
}

// class RecentClient {
//   RecentClient({
//     this.id,
//     this.clientName,
//     this.businessName,
//     this.region,
//     this.phone,
//     this.rep,
//     this.lastVisitAt,
//     this.updatedAt,
//   });

//   RecentClient.fromJson(Map<String, dynamic> json) {
//     id = json['id'] as int?;
//     clientName = json['client_name'] as String?;
//     businessName = json['business_name'] as String?;
//     region = json['region'] as String?;
//     phone = json['phone'] as String?;
//     rep = json['rep'] != null
//         ? RepInfo.fromJson(json['rep'] as Map<String, dynamic>)
//         : null;
//     lastVisitAt = json['last_visit_at'] as String?;
//     updatedAt = json['updated_at'] as String?;
//   }

//   int? id;
//   String? clientName;
//   String? businessName;
//   String? region;
//   String? phone;
//   RepInfo? rep;
//   String? lastVisitAt;
//   String? updatedAt;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['client_name'] = clientName;
//     map['business_name'] = businessName;
//     map['region'] = region;
//     map['phone'] = phone;
//     if (rep != null) map['rep'] = rep!.toJson();
//     map['last_visit_at'] = lastVisitAt;
//     map['updated_at'] = updatedAt;
//     return map;
//   }
// }

class RepInfo {
  RepInfo({this.id, this.name});

  RepInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
  }

  int? id;
  String? name;

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
