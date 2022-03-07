// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DetailsModel {
  final int id;
  final String name;
  final int accountId;
  final String status;
  final double peakPower;
  final String lastUpdateTime;
  final String currency;
  final String installationDate;
  final String ptoDate;
  final String notes;
  final String type;
  final Location location;
  final PrimaryModule primaryModule;
  final Uris uris;
  final PublicSettings publicSettings;
  DetailsModel({
    required this.id,
    required this.name,
    required this.accountId,
    required this.status,
    required this.peakPower,
    required this.lastUpdateTime,
    required this.currency,
    required this.installationDate,
    required this.ptoDate,
    required this.notes,
    required this.type,
    required this.location,
    required this.primaryModule,
    required this.uris,
    required this.publicSettings,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'accountId': accountId,
      'status': status,
      'peakPower': peakPower,
      'lastUpdateTime': lastUpdateTime,
      'currency': currency,
      'installationDate': installationDate,
      'ptoDate': ptoDate,
      'notes': notes,
      'type': type,
      'location': location.toMap(),
      'primaryModule': primaryModule.toMap(),
      'uris': uris.toMap(),
      'publicSettings': publicSettings.toMap(),
    };
  }

  factory DetailsModel.fromMap(Map<String, dynamic> map) {
    return DetailsModel(
      id: (map['id'] ?? 0) as int,
      name: (map['name'] ?? '') as String,
      accountId: (map['accountId'] ?? 0) as int,
      status: (map['status'] ?? '') as String,
      peakPower: (map['peakPower'] ?? 0.0) as double,
      lastUpdateTime: (map['lastUpdateTime'] ?? '') as String,
      currency: (map['currency'] ?? '') as String,
      installationDate: (map['installationDate'] ?? '') as String,
      ptoDate: (map['ptoDate'] ?? '') as String,
      notes: (map['notes'] ?? '') as String,
      type: (map['type'] ?? '') as String,
      location: Location.fromMap(map['location'] as Map<String,dynamic>),
      primaryModule: PrimaryModule.fromMap(map['primaryModule'] as Map<String,dynamic>),
      uris: Uris.fromMap(map['uris'] as Map<String,dynamic>),
      publicSettings: PublicSettings.fromMap(map['publicSettings'] as Map<String,dynamic>),
    );
  }

  factory DetailsModel.fromJson(String source) =>
      DetailsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Location {
  final String country;
  final String city;
  final String address;
  final String address2;
  final String zip;
  final String timeZone;
  final String countryCode;
  Location({
    required this.country,
    required this.city,
    required this.address,
    required this.address2,
    required this.zip,
    required this.timeZone,
    required this.countryCode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'country': country,
      'city': city,
      'address': address,
      'address2': address2,
      'zip': zip,
      'timeZone': timeZone,
      'countryCode': countryCode,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      country: (map['country'] ?? '') as String,
      city: (map['city'] ?? '') as String,
      address: (map['address'] ?? '') as String,
      address2: (map['address2'] ?? '') as String,
      zip: (map['zip'] ?? '') as String,
      timeZone: (map['timeZone'] ?? '') as String,
      countryCode: (map['countryCode'] ?? '') as String,
    );
  }

  factory Location.fromJson(String source) =>
      Location.fromMap(json.decode(source) as Map<String, dynamic>);
}

class PrimaryModule {
  
  final String manufacturerName;
  final String modelName;
  final double maximumPower;
  PrimaryModule({
    required this.manufacturerName,
    required this.modelName,
    required this.maximumPower,
  });
 

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'manufacturerName': manufacturerName,
      'modelName': modelName,
      'maximumPower': maximumPower,
    };
  }

  factory PrimaryModule.fromMap(Map<String, dynamic> map) {
    return PrimaryModule(
      manufacturerName: (map['manufacturerName'] ?? '') as String,
      modelName: (map['modelName'] ?? '') as String,
      maximumPower: (map['maximumPower'] ?? 0.0) as double,
    );
  }

  factory PrimaryModule.fromJson(String source) => PrimaryModule.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Uris {
  final String SITEIMAGE;
  final String DATAPERIOD;
  final String INSTALLERIMAGE;
  final String DETAILS;
  final String OVERVIEW;
  Uris({
    required this.SITEIMAGE,
    required this.DATAPERIOD,
    required this.INSTALLERIMAGE,
    required this.DETAILS,
    required this.OVERVIEW,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'SITE_IMAGE': SITEIMAGE,
      'DATA_PERIOD': DATAPERIOD,
      'INSTALLER_IMAGE': INSTALLERIMAGE,
      'DETAILS': DETAILS,
      'OVERVIEW': OVERVIEW,
    };
  }

  factory Uris.fromMap(Map<String, dynamic> map) {
    return Uris(
      SITEIMAGE: (map['SITE_IMAGE'] ?? '') as String,
      DATAPERIOD: (map['DATA_PERIOD'] ?? '') as String,
      INSTALLERIMAGE: (map['INSTALLER_IMAGE'] ?? '') as String,
      DETAILS: (map['DETAILS'] ?? '') as String,
      OVERVIEW: (map['OVERVIEW'] ?? '') as String,
    );
  }

  factory Uris.fromJson(String source) => Uris.fromMap(json.decode(source) as Map<String, dynamic>);
}

class PublicSettings {
  final bool isPublic;
  PublicSettings({
    required this.isPublic,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isPublic': isPublic,
    };
  }

  factory PublicSettings.fromMap(Map<String, dynamic> map) {
    return PublicSettings(
      isPublic: (map['isPublic'] ?? false) as bool,
    );
  }

  factory PublicSettings.fromJson(String source) => PublicSettings.fromMap(json.decode(source) as Map<String, dynamic>);
}
