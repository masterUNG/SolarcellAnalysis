import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class EnvBenefitsModel {
  final GasEmissionSaved gasEmissionSaved;
  final double treesPlanted;
  final double lightBulbs;
  EnvBenefitsModel({
    required this.gasEmissionSaved,
    required this.treesPlanted,
    required this.lightBulbs,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gasEmissionSaved': gasEmissionSaved.toMap(),
      'treesPlanted': treesPlanted,
      'lightBulbs': lightBulbs,
    };
  }

  factory EnvBenefitsModel.fromMap(Map<String, dynamic> map) {
    return EnvBenefitsModel(
      gasEmissionSaved: GasEmissionSaved.fromMap(map['gasEmissionSaved'] as Map<String,dynamic>),
      treesPlanted: (map['treesPlanted'] ?? 0.0) as double,
      lightBulbs: (map['lightBulbs'] ?? 0.0) as double,
    );
  }

  factory EnvBenefitsModel.fromJson(String source) => EnvBenefitsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class GasEmissionSaved {
  final String units;
  final double co2;
  final double so2;
  final double nox;
  GasEmissionSaved({
    required this.units,
    required this.co2,
    required this.so2,
    required this.nox,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'units': units,
      'co2': co2,
      'so2': so2,
      'nox': nox,
    };
  }

  factory GasEmissionSaved.fromMap(Map<String, dynamic> map) {
    return GasEmissionSaved(
      units: (map['units'] ?? '') as String,
      co2: (map['co2'] ?? 0.0) as double,
      so2: (map['so2'] ?? 0.0) as double,
      nox: (map['nox'] ?? 0.0) as double,
    );
  }

  factory GasEmissionSaved.fromJson(String source) =>
      GasEmissionSaved.fromMap(json.decode(source) as Map<String, dynamic>);
}
