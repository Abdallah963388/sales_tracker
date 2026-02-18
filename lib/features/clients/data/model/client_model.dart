class ClientModel {
  ClientModel({
    required this.id,
    required this.name,
    required this.placeName,
    required this.area,
    required this.email,
    required this.phone,
    required this.details,
    this.location,
    this.visitDetails,
  }); // ممكن تكون null قبل إضافة الزيارة

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as int,
      name: json['name'] as String,
      placeName: json['placeName'] as String? ?? '',
      area: json['area'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      details: json['details'] as String? ?? '',
      location: json['location'] as String?,
      visitDetails: json['visitDetails'] as String?,
    );
  }

  final int id;
  final String name;
  final String placeName;
  final String area;
  final String email;
  final String phone;
  final String details;
  final String? location; // ممكن تكون null قبل تحديد الموقع
  final String? visitDetails;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'placeName': placeName,
      'area': area,
      'email': email,
      'phone': phone,
      'details': details,
      'location': location,
      'visitDetails': visitDetails,
    };
  }
}





// class ProductModel {
//   ProductModel({
//     required this.id,
//     required this.name,
//     required this.price,
//   });

//   factory ProductModel.fromJson(Map<String, dynamic> json) {
//     return ProductModel(
//       id: json['id'] as int,
//       name: json['name'] as String,
//       price: (json['price'] as num).toDouble(),
//     );
//   }

//   final int id;
//   final String name;
//   final double price;

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'price': price,
//     };
//   }
// }
