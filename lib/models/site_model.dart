import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SiteModel {
  final String apiKey;
  final int pinCode;
  SiteModel({
    required this.apiKey,
    required this.pinCode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'apiKey': apiKey,
      'pinCode': pinCode,
    };
  }

  factory SiteModel.fromMap(Map<String, dynamic> map) {
    return SiteModel(
      apiKey: (map['apiKey'] ?? '') as String,
      pinCode: (map['pinCode'] ?? 0) as int,
    );
  }

  factory SiteModel.fromJson(String source) => SiteModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
