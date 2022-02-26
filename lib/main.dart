import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solacellanalysin/states/find_apikey.dart';
import 'package:solacellanalysin/states/main_home.dart';
import 'package:solacellanalysin/utility/my_constant.dart';

final Map<String, WidgetBuilder> map = {
  MyConstant.routeMainHome: (context) => const MainHome(),
  MyConstant.routeFindAPIkey: (context) => const FindApiKey(),
};

String? firstState;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var result = preferences.getStringList('data');
  print('result ==> $result');
  if (result == null) {
    firstState = MyConstant.routeFindAPIkey;
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
      routes: map,
      initialRoute: firstState,
    );
  }
}
