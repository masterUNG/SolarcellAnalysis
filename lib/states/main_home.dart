import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solacellanalysin/models/details_model.dart';
import 'package:solacellanalysin/models/menu_model.dart';
import 'package:solacellanalysin/models/overview_model.dart';
import 'package:solacellanalysin/utility/my_constant.dart';
import 'package:solacellanalysin/widgets/show_card.dart';
import 'package:solacellanalysin/widgets/show_progress.dart';
import 'package:solacellanalysin/widgets/show_text.dart';

class MainHome extends StatefulWidget {
  const MainHome({
    Key? key,
  }) : super(key: key);

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  DetailsModel? detailsModel;
  bool load = true;
  String? urlImage;

  var titleMenus = <String>[
    'Site Details',
    'Settings',
    'About',
    'LogOut',
  ];
  var pathRounts = <String>[
    MyConstant.routeSiteDetails,
    MyConstant.routeSettings,
    MyConstant.routeAbout,
    '',
  ];

  var menuModels = <MenuModel>[];
  var chooseMenu;

  OverviewModel? overviewModel;

  @override
  void initState() {
    super.initState();
    readData();
    setupMenu();
  }

  void setupMenu() {
    int index = 0;
    for (var item in titleMenus) {
      MenuModel model = MenuModel(title: item, pathRoute: pathRounts[index]);
      menuModels.add(model);
      index++;
    }
  }

  Future<void> readData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var datas = preferences.getStringList('data');

    // for Read Details
    String pathAPI =
        'https://monitoringapi.solaredge.com/site/${datas![0]}/details?api_key=${datas[1]}';
    await Dio().get(pathAPI).then((value) {
      Map<String, dynamic> map = value.data;
      var detailsMap = map['details'];

      setState(() {
        detailsModel = DetailsModel.fromMap(detailsMap);
        load = false;
        urlImage =
            'https://monitoringapi.solaredge.com${detailsModel!.uris.SITEIMAGE}?hash=123456789&api_key=${datas[1]}';
      });
    });

    // for OverView
    String pathOverView =
        'https://monitoringapi.solaredge.com/site/${datas![0]}/overview?api_key=${datas[1]}';
    await Dio().get(pathOverView).then((value) {
      var result = value.data['overview'];
      overviewModel = OverviewModel.fromMap(result);
      print('result == $value');
      print('8Mar current Power ==>> ${overviewModel!.currentPower.power}');
    });

    // for CurrentPowerFlow
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? const ShowProgress()
          : LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  newInforTop(constraints),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ShowCard(
                        size: constraints.maxWidth * 0.33,
                        label: '12.34 kW',
                        pathImage: 'images/current.png',
                      ),
                      ShowCard(
                        size: constraints.maxWidth * 0.33,
                        label: '56.78 kW',
                        pathImage: 'images/load.png',
                      ),
                      ShowCard(
                        size: constraints.maxWidth * 0.33,
                        label: '45.67 kW',
                        pathImage: 'images/grid.png',
                      ),
                    ],
                  ),
                ],
              );
            }),
    );
  }

  Container newInforTop(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth,
      height: 200,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(urlImage!), fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShowText(
                    label: detailsModel!.name,
                    textStyle: MyConstant().h2WhiteStyle(),
                  ),
                  newDropDownMenu(),
                ],
              ),
              ListTile(
                leading: const Icon(
                  Icons.location_on_outlined,
                  color: Colors.white,
                ),
                title: ShowText(
                  label: detailsModel!.location.address,
                  textStyle: MyConstant().h3WhiteStyle(),
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.flash_on_sharp,
                    color: Colors.white,
                  ),
                  ShowText(
                    label: detailsModel!.peakPower.toString(),
                    textStyle: MyConstant().h1WhiteStyle(),
                  ),
                  ShowText(
                    label: ' kWp',
                    textStyle: MyConstant().h3WhiteStyle(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget newDropDownMenu() => DropdownButton<dynamic>(
      icon: const Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      value: chooseMenu,
      items: menuModels
          .map(
            (e) => DropdownMenuItem(
              child: ShowText(label: e.title),
              value: e,
            ),
          )
          .toList(),
      onChanged: (value) {
        MenuModel menuModel = value;
        if (menuModel.pathRoute.isNotEmpty) {
          print('Status Route ==>> ${menuModel.pathRoute}');
          Navigator.pushNamed(context, menuModel.pathRoute);
        } else {
          print('Status Logout');
        }
      });
}
