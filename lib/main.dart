import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solacellanalysin/states/about.dart';
import 'package:solacellanalysin/states/add_site_id.dart';
import 'package:solacellanalysin/states/find_apikey.dart';
import 'package:solacellanalysin/states/login_by_name.dart';
import 'package:solacellanalysin/states/main_home.dart';
import 'package:solacellanalysin/states/setting.dart';
import 'package:solacellanalysin/states/site_details.dart';
import 'package:solacellanalysin/utility/my_constant.dart';

final Map<String, WidgetBuilder> map = {
  MyConstant.routeMainHome: (context) => const MainHome(),
  MyConstant.routeFindAPIkey: (context) => const FindApiKey(),
  MyConstant.routeSiteDetails: (context) => const SiteDetail(),
  MyConstant.routeSettings: (context) => const Setting(),
  MyConstant.routeAbout: (context) => const About(),
  MyConstant.routeAddSiteId: (context) => const AddSiteId(),
  MyConstant.routeLoginByName:(context) => const LoginByName(),
};

String? firstState;

Future<void> main() async {
  HttpOverrides.global = MyOverrideHttp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var result = preferences.getStringList('data');
  // print('result ==> $result');
  if (result == null) {
    firstState = MyConstant.routeLoginByName;
  } else {
    firstState = MyConstant.routeMainHome;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyConstant.appName,
      debugShowCheckedModeBanner: false,
      routes: map,
      initialRoute: firstState,
    );
  }
}

class MyOverrideHttp extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
