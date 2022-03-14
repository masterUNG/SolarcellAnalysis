import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solacellanalysin/utility/my_constant.dart';
import 'package:solacellanalysin/widgets/show_card.dart';

class ShowSignOut extends StatelessWidget {
  const ShowSignOut({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear().then((value) => Navigator.pushNamedAndRemoveUntil(
            context, MyConstant.routeLoginByName, (route) => false));
      },
      child: const ShowCard(
          size: 120, label: 'Sign Out', pathImage: 'images/signout.png'),
    );
  }
}
