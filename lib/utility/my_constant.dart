import 'package:flutter/material.dart';

class MyConstant {
  static String routeMainHome = '/mainHome';
  static String routeFindAPIkey = '/findApiKey';
  static String routeSiteDetails = '/siteDetails';
  static String routeSettings = '/settings';
  static String routeAbout = '/about';
  static String routeAddSiteId = '/addSiteId';

  //Paper
  static String apiKey = '09HQHOJQYBLAF6N96LHGCGRFS68X13A9';
  static String siteId = '2345733';

  //Oh Ka Ju
  // static String apiKey = 'VVOX8PCKBXGAHY3E2HKVJLTHDWSZH81M';
  // static String siteId = '1598054';

  static Color primary = const Color(0xffe03a07);
  static Color dark =  Colors.black;
  static Color light = const Color(0xffff6f3a);

  TextStyle h1Style() => TextStyle(
        color: dark,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      );

  TextStyle h1WhiteStyle() => const TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      );

  TextStyle h2Style() => TextStyle(
        color: dark,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      );

  TextStyle h2WhiteStyle() => const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      );

  TextStyle h3Style() => TextStyle(
        color: dark,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

  TextStyle h3WhiteStyle() => const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

       TextStyle h3GreenStyle() => const TextStyle(
        color: Color.fromARGB(255, 19, 116, 22),
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );
}
