import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SiteModel {
  final String apiKey;
  final int pinCode;
  final String name;
  final Timestamp mainten1;
  final Timestamp mainten2;
  final Timestamp mainten3;
  SiteModel({
    required this.apiKey,
    required this.pinCode,
    required this.name,
    required this.mainten1,
    required this.mainten2,
    required this.mainten3,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'apiKey': apiKey,
      'pinCode': pinCode,
      'name': name,
      'mainten1': mainten1,
      'mainten2': mainten2,
      'mainten3': mainten3,
    };
  }

  factory SiteModel.fromMap(Map<String, dynamic> map) {
    return SiteModel(
      apiKey: (map['apiKey'] ?? '') as String,
      pinCode: (map['pinCode'] ?? 0) as int,
      name: (map['name'] ?? '') as String,
      mainten1: (map['mainten1']),
      mainten2: (map['mainten2']),
      mainten3: (map['mainten3']),
    );
  }

  factory SiteModel.fromJson(String source) =>
      SiteModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
