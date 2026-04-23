class AddClientResponse {
  AddClientResponse({
    this.status,
    this.message,
    this.data,
  });

  AddClientResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool?;
    message = json['message'] as String?;
    data = json['data'] != null
        ? CreateClient.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }

  bool? status;
  String? message;
  CreateClient? data;
}

class CreateClient {
  CreateClient({
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
    this.createdAt,
    this.updatedAt,
    this.visitsCount,
  });

  CreateClient.fromJson(Map<String, dynamic> json) {
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
  String? createdAt;
  String? updatedAt;
  int? visitsCount;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rep_id': repId,
      'client_name': clientName,
      'business_name': businessName,
      'business_details': businessDetails,
      'region': region,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'visits_count': visitsCount,
    };
  }
}
