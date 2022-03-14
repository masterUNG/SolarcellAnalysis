// ignore_for_file: unrelated_type_equality_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solacellanalysin/models/site_model.dart';
import 'package:solacellanalysin/utility/my_constant.dart';
import 'package:solacellanalysin/utility/my_dialog.dart';
import 'package:solacellanalysin/widgets/show_button.dart';
import 'package:solacellanalysin/widgets/show_form.dart';
import 'package:solacellanalysin/widgets/show_signout.dart';
import 'package:solacellanalysin/widgets/show_text.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String? currentPinCode, newPinCode;
  var datas = <String>[];
  SiteModel? siteModel;

  @override
  void initState() {
    super.initState();
    readSite();
  }

  Future<void> readSite() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    datas = preferences.getStringList('data')!;

    await FirebaseFirestore.instance
        .collection('site')
        .doc(datas[0])
        .get()
        .then((value) {
      siteModel = SiteModel.fromMap(value.data()!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, MyConstant.routeMainHome, (route) => false),
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Setting'),
        foregroundColor: MyConstant.dark,
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Column(
            children: [
              newTitle('Change PinCode'),
              ShowForm(
                  textInputType: TextInputType.number,
                  hint: 'Current PinCode',
                  changeFunc: (String string) =>
                      currentPinCode = string.trim()),
              ShowForm(
                  textInputType: TextInputType.number,
                  hint: 'New PinCode',
                  changeFunc: (String string) => newPinCode = string.trim()),
              ShowButton(
                  label: 'Change Pincode',
                  pressFunc: () {
                    if ((currentPinCode?.isEmpty ?? true) ||
                        (newPinCode?.isEmpty ?? true)) {
                      MyDialog(context: context).normalDialog(
                          title: 'Have Space',
                          message: 'Please Fill Every Blank');
                    } else {
                      if (currentPinCode != siteModel!.pinCode.toString()) {
                        MyDialog(context: context).normalDialog(
                            title: 'Current Pin Code False ?',
                            message: 'Please Fill Curent Pin Code Again');
                      } else if (newPinCode!.length != 4) {
                        MyDialog(context: context).normalDialog(
                            title: 'newPinCode must 4 digi',
                            message: 'Please Fill New Pin Code only 4 digi');
                      } else {
                        processUpdatePinCode();
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
      floatingActionButton: const ShowSignOut(),
    );
  }

  Row newTitle(String label) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ShowText(
            label: label,
            textStyle: MyConstant().h2Style(),
          ),
        ),
      ],
    );
  }

  Future<void> processUpdatePinCode() async {
    Map<String, dynamic> map = {};
    map['pinCode'] = int.parse(newPinCode!);
    await FirebaseFirestore.instance
        .collection('site')
        .doc(datas[0])
        .update(map)
        .then((value) {
      Navigator.pushNamedAndRemoveUntil(
          context, MyConstant.routeMainHome, (route) => false);
    });
  }
}
