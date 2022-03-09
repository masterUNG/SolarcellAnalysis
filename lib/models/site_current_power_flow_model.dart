import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SiteCurrentPowerFlow {
  final String unit;
  final Grid grid;
  final Load load;
  final Pv pv;
  SiteCurrentPowerFlow({
    required this.unit,
    required this.grid,
    required this.load,
    required this.pv,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'unit': unit,
      'GRID': grid.toMap(),
      'LOAD': load.toMap(),
      'PV': pv.toMap(),
    };
  }

  factory SiteCurrentPowerFlow.fromMap(Map<String, dynamic> map) {
    return SiteCurrentPowerFlow(
      unit: (map['unit'] ?? '') as String,
      grid: Grid.fromMap(map['GRID'] as Map<String,dynamic>),
      load: Load.fromMap(map['LOAD'] as Map<String,dynamic>),
      pv: Pv.fromMap(map['PV'] as Map<String,dynamic>),
    );
  }

  factory SiteCurrentPowerFlow.fromJson(String source) => SiteCurrentPowerFlow.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Grid {
  final String status;
  final double currentPower;
  Grid({
    required this.status,
    required this.currentPower,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'currentPower': currentPower,
    };
  }

  factory Grid.fromMap(Map<String, dynamic> map) {
    return Grid(
      status: (map['status'] ?? '') as String,
      currentPower: (map['currentPower'] ?? 0.0) as double,
    );
  }

  factory Grid.fromJson(String source) =>
      Grid.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Load {
  final String status;
  final double currentPower;
  Load({
    required this.status,
    required this.currentPower,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'currentPower': currentPower,
    };
  }

  factory Load.fromMap(Map<String, dynamic> map) {
    return Load(
      status: (map['status'] ?? '') as String,
      currentPower: (map['currentPower'] ?? 0.0) as double,
    );
  }

  factory Load.fromJson(String source) =>
      Load.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Pv {
  final String status;
  Pv({
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
    };
  }

  factory Pv.fromMap(Map<String, dynamic> map) {
    return Pv(
      status: (map['status'] ?? '') as String,
    );
  }

  factory Pv.fromJson(String source) =>
      Pv.fromMap(json.decode(source) as Map<String, dynamic>);
}
