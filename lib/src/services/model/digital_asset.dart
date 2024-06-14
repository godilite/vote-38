class DigitalAsset {
  final String name;
  final String description;
  final String issuer;
  final String code;
  final String url;

  DigitalAsset({
    required this.name,
    required this.description,
    required this.issuer,
    required this.code,
    required this.url,
  });

  // Factory method to create an instance from a JSON map
  factory DigitalAsset.fromJson(Map<String, dynamic> json) {
    return DigitalAsset(
      name: json['name'] as String,
      description: json['description'] as String,
      issuer: json['issuer'] as String,
      code: json['code'] as String,
      url: json['url'] as String,
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'issuer': issuer,
      'code': code,
      'url': url,
    };
  }
}
