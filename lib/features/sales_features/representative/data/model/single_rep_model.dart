class SingleRepModel {
  SingleRepModel({this.status, this.message, this.data});

  SingleRepModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool?;
    message = json['message'] as String?;
    data = json['data'] != null
        ? SingleRepData.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }

  bool? status;
  String? message;
  SingleRepData? data;

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

class SingleRepData {
  SingleRepData({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.isActive,
    this.avatarUrl,
    this.clientsCount,
    this.visitsCount,
    this.createdAt,
    this.monthlyVisits,
    this.recentClients,
  });

  SingleRepData.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    email = json['email'] as String?;
    phone = json['phone'] as String?;
    isActive = json['is_active'] as bool?;
    avatarUrl = json['avatar_url'] as String?;
    clientsCount = json['clients_count'] as int?;
    visitsCount = json['visits_count'] as int?;
    createdAt = json['created_at'] as String?;

    if (json['monthly_visits'] != null) {
      monthlyVisits = List<dynamic>.from(json['monthly_visits'] as List);
    } else {
      monthlyVisits = [];
    }

    if (json['recent_clients'] != null) {
      recentClients = List<dynamic>.from(json['recent_clients'] as List);
    } else {
      recentClients = [];
    }
  }

  int? id;
  String? name;
  String? email;
  String? phone;
  bool? isActive;
  String? avatarUrl;
  int? clientsCount;
  int? visitsCount;
  String? createdAt;
  List<dynamic>? monthlyVisits;
  List<dynamic>? recentClients;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['phone'] = phone;
    map['is_active'] = isActive;
    map['avatar_url'] = avatarUrl;
    map['clients_count'] = clientsCount;
    map['visits_count'] = visitsCount;
    map['created_at'] = createdAt;
    map['monthly_visits'] = monthlyVisits;
    map['recent_clients'] = recentClients;
    return map;
  }
}
