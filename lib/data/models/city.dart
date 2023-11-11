class City {
  final String? name;
  final bool hasImage;

  const City({this.name, this.hasImage = false});

  Map toJson() {
    return {
      'name': name,
      'hasImage': hasImage,
    };
  }

  factory City.fromJson(Map json) {
    return City(
      name: json['name'],
      hasImage: json['hasImage'] ?? false,
    );
  }
}
