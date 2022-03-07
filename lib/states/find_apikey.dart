import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solacellanalysin/utility/my_constant.dart';
import 'package:solacellanalysin/widgets/show_button.dart';
import 'package:solacellanalysin/widgets/show_text.dart';

class FindApiKey extends StatefulWidget {
  const FindApiKey({Key? key}) : super(key: key);

  @override
  State<FindApiKey> createState() => _FindApiKeyState();
}

class _FindApiKeyState extends State<FindApiKey> {
  String? siteId, apiKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    siteId = MyConstant.siteId;
    apiKey = MyConstant.apiKey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ShowText(label: 'siteId = $siteId'),
          ShowText(label: 'apiKey = $apiKey'),
          ShowButton(
            label: 'Save API',
            pressFunc: () {
              processSaveAPI();
            },
          )
        ],
      ),
    );
  }

  Future<void> processSaveAPI() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var datas = <String>[];
    datas.add(siteId!);
    datas.add(apiKey!);
    preferences.setStringList('data', datas).then((value) =>
        Navigator.pushNamedAndRemoveUntil(
            context, MyConstant.routeMainHome, (route) => false));
  }
}
