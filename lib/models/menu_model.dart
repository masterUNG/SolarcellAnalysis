import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MenuModel {
  final String title;
  final String pathRoute;
  MenuModel({
    required this.title,
    required this.pathRoute,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'pathRoute': pathRoute,
    };
  }

  factory MenuModel.fromMap(Map<String, dynamic> map) {
    return MenuModel(
      title: (map['title'] ?? '') as String,
      pathRoute: (map['pathRoute'] ?? '') as String,
    );
  }

  factory MenuModel.fromJson(String source) => MenuModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
