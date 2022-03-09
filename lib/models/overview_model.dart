import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class OverviewModel {
  final String lastUpdateTime;
  final LifeTimeData lifeTimeData;
  final LastYearData lastYearData;
  final LastMonthData lastMonthData;
  final LastDayData lastDayData;
  final CurrentPower currentPower;
  OverviewModel({
    required this.lastUpdateTime,
    required this.lifeTimeData,
    required this.lastYearData,
    required this.lastMonthData,
    required this.lastDayData,
    required this.currentPower,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lastUpdateTime': lastUpdateTime,
      'lifeTimeData': lifeTimeData.toMap(),
      'lastYearData': lastYearData.toMap(),
      'lastMonthData': lastMonthData.toMap(),
      'lastDayData': lastDayData.toMap(),
      'currentPower': currentPower.toMap(),
    };
  }

  factory OverviewModel.fromMap(Map<String, dynamic> map) {
    return OverviewModel(
      lastUpdateTime: (map['lastUpdateTime'] ?? '') as String,
      lifeTimeData: LifeTimeData.fromMap(map['lifeTimeData'] as Map<String,dynamic>),
      lastYearData: LastYearData.fromMap(map['lastYearData'] as Map<String,dynamic>),
      lastMonthData: LastMonthData.fromMap(map['lastMonthData'] as Map<String,dynamic>),
      lastDayData: LastDayData.fromMap(map['lastDayData'] as Map<String,dynamic>),
      currentPower: CurrentPower.fromMap(map['currentPower'] as Map<String,dynamic>),
    );
  }

  factory OverviewModel.fromJson(String source) => OverviewModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class LifeTimeData {
  final double energy;
  final double revenue;
  LifeTimeData({
    required this.energy,
    required this.revenue,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'energy': energy,
      'revenue': revenue,
    };
  }

  factory LifeTimeData.fromMap(Map<String, dynamic> map) {
    return LifeTimeData(
      energy: (map['energy'] ?? 0.0) as double,
      revenue: (map['revenue'] ?? 0.0) as double,
    );
  }

  factory LifeTimeData.fromJson(String source) =>
      LifeTimeData.fromMap(json.decode(source) as Map<String, dynamic>);
}

class LastYearData {
  final double energy;
  LastYearData({
    required this.energy,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'energy': energy,
    };
  }

  factory LastYearData.fromMap(Map<String, dynamic> map) {
    return LastYearData(
      energy: (map['energy'] ?? 0.0) as double,
    );
  }

  factory LastYearData.fromJson(String source) => LastYearData.fromMap(json.decode(source) as Map<String, dynamic>);
}

class LastMonthData {
  final double energy;
  LastMonthData({
    required this.energy,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'energy': energy,
    };
  }

  factory LastMonthData.fromMap(Map<String, dynamic> map) {
    return LastMonthData(
      energy: (map['energy'] ?? 0.0) as double,
    );
  }

  factory LastMonthData.fromJson(String source) => LastMonthData.fromMap(json.decode(source) as Map<String, dynamic>);
}

class LastDayData {
  final double energy;
  LastDayData({
    required this.energy,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'energy': energy,
    };
  }

  factory LastDayData.fromMap(Map<String, dynamic> map) {
    return LastDayData(
      energy: (map['energy'] ?? 0.0) as double,
    );
  }

  factory LastDayData.fromJson(String source) => LastDayData.fromMap(json.decode(source) as Map<String, dynamic>);
}

class CurrentPower {
  final double power;
  CurrentPower({
    required this.power,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'power': power,
    };
  }

  factory CurrentPower.fromMap(Map<String, dynamic> map) {
    return CurrentPower(
      power: (map['power'] ?? 0.0) as double,
    );
  }

  factory CurrentPower.fromJson(String source) => CurrentPower.fromMap(json.decode(source) as Map<String, dynamic>);
}
