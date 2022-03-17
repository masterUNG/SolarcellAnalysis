import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class BannerModel {
  final String pathBanner;
  final String pathUrl;
  BannerModel({
    required this.pathBanner,
    required this.pathUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pathBanner': pathBanner,
      'pathUrl': pathUrl,
    };
  }

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      pathBanner: (map['pathBanner'] ?? '') as String,
      pathUrl: (map['pathUrl'] ?? '') as String,
    );
  }

  factory BannerModel.fromJson(String source) => BannerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
