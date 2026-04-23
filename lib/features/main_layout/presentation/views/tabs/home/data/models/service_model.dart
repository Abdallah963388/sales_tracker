class Service {
  Service({
    required this.id,
    required this.name,
    required this.overview,
    required this.keyFeatures,
    required this.typicalProcess,
    required this.image,
    required this.rating,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as int,
      name: json['name'] as String,
      overview: json['overview'] as String,
      keyFeatures: List<String>.from(json['key_features'] as List),
      typicalProcess: List<String>.from(json['typical_process'] as List),
      image: json['image'] as String,
      rating: json['rating'] as String,
    );
  }
  final int id;
  final String name;
  final String overview;
  final List<String> keyFeatures;
  final List<String> typicalProcess;
  final String image;
  final String rating;
}
