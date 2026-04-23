class RequestServiceModel {
  RequestServiceModel({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.messageText,
    required this.serviceName,
  });
  factory RequestServiceModel.fromJson(Map<String, dynamic> json) {
    return RequestServiceModel(
      name: json['name'].toString(),
      phoneNumber: json['phone'].toString(),
      email: json['email'].toString(),
      messageText: json['message'].toString(),
      serviceName: json['service_name'].toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phoneNumber,
      'email': email,
      'message': messageText,
      'service_name': serviceName,
    };
  }

  final String name;
  final String phoneNumber;
  final String email;
  final String messageText;
  final String serviceName;
}
