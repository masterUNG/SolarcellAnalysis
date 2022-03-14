import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:solacellanalysin/models/site_model.dart';
import 'package:solacellanalysin/states/check_pin_code.dart';
import 'package:solacellanalysin/utility/my_constant.dart';
import 'package:solacellanalysin/utility/my_dialog.dart';
import 'package:solacellanalysin/widgets/show_button.dart';
import 'package:solacellanalysin/widgets/show_form.dart';
import 'package:solacellanalysin/widgets/show_imge.dart';

class LoginByName extends StatefulWidget {
  const LoginByName({Key? key}) : super(key: key);

  @override
  State<LoginByName> createState() => _LoginByNameState();
}

class _LoginByNameState extends State<LoginByName> {
  String? siteName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                newLogo(constraints),
                newSiteName(),
                newLogin(),
              ],
            ),
          ),
        );
      }),
    );
  }

  ShowButton newLogin() => ShowButton(
      label: 'Login',
      pressFunc: () {
        if (siteName?.isEmpty ?? true) {
          MyDialog(context: context).normalDialog(
              title: 'No SiteName', message: 'Please Fill SiteName');
        } else {
          processCheckSiteName();
        }
      });

  ShowForm newSiteName() {
    return ShowForm(
      hint: 'SiteName',
      changeFunc: (String string) => siteName = string.trim(),
    );
  }

  SizedBox newLogo(BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth * 0.4,
      child: const ShowImage(),
    );
  }

  Future<void> processCheckSiteName() async {
    await FirebaseFirestore.instance
        .collection('site')
        .where('name', isEqualTo: siteName)
        .get()
        .then((value) {
      print('value ==> ${value.docs}');
      if (value.docs.isEmpty) {
        MyDialog(context: context).actionDialog(
            title: 'SiteName False ?',
            message: 'Please Fill new SiteName or Login by Site ID',
            labePressFunc: 'Login by Site ID',
            pressFunc: () => Navigator.pushNamedAndRemoveUntil(
                context, MyConstant.routeAddSiteId, (route) => false));
      } else {
        for (var item in value.docs) {
          String siteId = item.id;
          SiteModel siteModel = SiteModel.fromMap(item.data());
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CheckPinCode(siteModel: siteModel, siteId: siteId),
              ),
              (route) => false);
        }
      }
    });
  }
}
