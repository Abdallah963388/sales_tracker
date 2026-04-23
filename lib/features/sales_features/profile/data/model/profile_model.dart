class UserProfile {
  UserProfile({this.status, this.message, this.data});

  UserProfile.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool?;
    message = json['message'] as String?;
    data = json['data'] != null
        ? UserProfileData.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }

  bool? status;
  String? message;
  UserProfileData? data;

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

class UserProfileData {
  UserProfileData({
    this.id,
    this.name,
    this.email,
    this.role,
    this.phone,
    this.isActive,
    this.avatarUrl,
    this.createdAt,
  });

  UserProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    email = json['email'] as String?;
    role = json['role'] as String?;
    phone = json['phone'] as String?;
    isActive = json['is_active'] as bool?;
    avatarUrl = json['avatar_url'] as String?;
    createdAt = json['created_at'] as String?;
  }

  int? id;
  String? name;
  String? email;
  String? role;
  String? phone;
  bool? isActive;
  String? avatarUrl;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['role'] = role;
    map['phone'] = phone;
    map['is_active'] = isActive;
    map['avatar_url'] = avatarUrl;
    map['created_at'] = createdAt;
    return map;
  }
}
