import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SiteModel {
  final String apiKey;
  final int pinCode;
  final String name;
  SiteModel({
    required this.apiKey,
    required this.pinCode,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'apiKey': apiKey,
      'pinCode': pinCode,
      'name': name,
    };
  }

  factory SiteModel.fromMap(Map<String, dynamic> map) {
    return SiteModel(
      apiKey: (map['apiKey'] ?? '') as String,
      pinCode: (map['pinCode'] ?? 0) as int,
      name: (map['name'] ?? '') as String,
    );
  }

  factory SiteModel.fromJson(String source) =>
      SiteModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
