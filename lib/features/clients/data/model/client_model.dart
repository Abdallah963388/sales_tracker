class ClientsResponse {
  ClientsResponse({this.status, this.message, this.data});

  ClientsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool?;
    message = json['message'] as String?;
    data = json['data'] != null
        ? ClientsData.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }

  bool? status;
  String? message;
  ClientsData? data;

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

class ClientsData {
  ClientsData({this.clients, this.pagination});

  ClientsData.fromJson(Map<String, dynamic> json) {
    if (json['clients'] != null) {
      clients = List<Client>.from(
        (json['clients'] as List).map(
          (x) => Client.fromJson(x as Map<String, dynamic>),
        ),
      );
    } else {
      clients = [];
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
        : null;
  }

  List<Client>? clients;
  Pagination? pagination;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['clients'] = clients?.map((x) => x.toJson()).toList();
    if (pagination != null) {
      map['pagination'] = pagination!.toJson();
    }
    return map;
  }
}

class Client {
  Client({
    this.id,
    this.repId,
    this.clientName,
    this.businessName,
    this.businessDetails,
    this.region,
    this.location,
    this.latitude,
    this.longitude,
    this.phone,
    this.email,
    this.lastVisitAt,
    this.createdAt,
    this.updatedAt,
    this.visitsCount,
  });

  Client.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    repId = json['rep_id'] as int?;
    clientName = json['client_name'] as String?;
    businessName = json['business_name'] as String?;
    businessDetails = json['business_details'] as String?;
    region = json['region'] as String?;
    location = json['location'] as String?;
    latitude = (json['latitude'] as num?)?.toDouble();
    longitude = (json['longitude'] as num?)?.toDouble();
    phone = json['phone'] as String?;
    email = json['email'] as String?;
    lastVisitAt = json['last_visit_at'] as String?;
    createdAt = json['created_at'] as String?;
    updatedAt = json['updated_at'] as String?;
    visitsCount = json['visits_count'] as int?;
  }

  int? id;
  int? repId;
  String? clientName;
  String? businessName;
  String? businessDetails;
  String? region;
  String? location;
  double? latitude;
  double? longitude;
  String? phone;
  String? email;
  String? lastVisitAt;
  String? createdAt;
  String? updatedAt;
  int? visitsCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['rep_id'] = repId;
    map['client_name'] = clientName;
    map['business_name'] = businessName;
    map['business_details'] = businessDetails;
    map['region'] = region;
    map['location'] = location;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['phone'] = phone;
    map['email'] = email;
    map['last_visit_at'] = lastVisitAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['visits_count'] = visitsCount;
    return map;
  }
}

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
