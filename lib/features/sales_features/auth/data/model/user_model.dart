class UserModel {
  UserModel({this.status, this.message, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool?;
    message = json['message'] as String?;
    data = json['data'] != null
        ? UserData.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }

  bool? status;
  String? message;
  UserData? data;

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

class UserData {
  UserData({this.user, this.token, this.tokenType});

  UserData.fromJson(Map<String, dynamic> json) {
    token = json['token'] as String?;
    tokenType = json['token_type'] as String?;
    user = json['user'] != null
        ? User.fromJson(json['user'] as Map<String, dynamic>)
        : null;
  }

  String? token;
  String? tokenType;
  User? user;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['token'] = token;
    data['token_type'] = tokenType;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.phone,
    this.isActive,
    this.avatarUrl,
    this.createdAt,
  });

  User.fromJson(Map<String, dynamic> json) {
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
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    data['phone'] = phone;
    data['is_active'] = isActive;
    data['avatar_url'] = avatarUrl;
    data['created_at'] = createdAt;
    return data;
  }
}
