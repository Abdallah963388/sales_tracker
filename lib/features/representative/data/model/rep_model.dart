class RepsResponse {
  RepsResponse({this.status, this.message, this.data});

  RepsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool?;
    message = json['message'] as String?;
    data = json['data'] != null
        ? RepsData.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }

  bool? status;
  String? message;
  RepsData? data;

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

class RepsData {
  RepsData({this.reps, this.pagination});

  RepsData.fromJson(Map<String, dynamic> json) {
    if (json['reps'] != null) {
      reps = List<Rep>.from(
        (json['reps'] as List).map(
          (x) => Rep.fromJson(x as Map<String, dynamic>),
        ),
      );
    } else {
      reps = [];
    }

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
        : null;
  }

  List<Rep>? reps;
  Pagination? pagination;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reps'] = reps?.map((x) => x.toJson()).toList();
    if (pagination != null) {
      map['pagination'] = pagination!.toJson();
    }
    return map;
  }
}

class Rep {
  Rep({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.isActive,
    this.avatarUrl,
    this.clientsCount,
    this.visitsCount,
    this.createdAt,
  });

  Rep.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    email = json['email'] as String?;
    phone = json['phone'] as String?;
    isActive = json['is_active'] as bool?;
    avatarUrl = json['avatar_url'] as String?;
    clientsCount = json['clients_count'] as int?;
    visitsCount = json['visits_count'] as int?;
    createdAt = json['created_at'] as String?;
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
