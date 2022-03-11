import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solacellanalysin/models/details_model.dart';
import 'package:solacellanalysin/models/menu_model.dart';
import 'package:solacellanalysin/models/overview_model.dart';
import 'package:solacellanalysin/models/site_current_power_flow_model.dart';
import 'package:solacellanalysin/utility/my_constant.dart';
import 'package:solacellanalysin/widgets/show_card.dart';
import 'package:solacellanalysin/widgets/show_progress.dart';
import 'package:solacellanalysin/widgets/show_signout.dart';
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
  SiteCurrentPowerFlow? siteCurrentPowerFlow;

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
        'https://monitoringapi.solaredge.com/site/${datas[0]}/overview?api_key=${datas[1]}';
    await Dio().get(pathOverView).then((value) {
      var result = value.data['overview'];
      setState(() {
        overviewModel = OverviewModel.fromMap(result);
      });
    });

    // for CurrentPowerFlow
    String pathCurrentPowerFlow =
        'https://monitoringapi.solaredge.com/site/${datas[0]}/currentPowerFlow?api_key=${datas[1]}';
    await Dio().get(pathCurrentPowerFlow).then((value) {
      var result = value.data['siteCurrentPowerFlow'];
      print('reslut CurrentPowerFlow ==>> $result');
      setState(() {
        siteCurrentPowerFlow = SiteCurrentPowerFlow.fromMap(result);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ShowSignOut(),
      body: load
          ? const ShowProgress()
          : LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  newInforTop(constraints),
                  newPowerLoadGrid(constraints),
                  SizedBox(
                    height: constraints.maxWidth * 0.25,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const ShowText(label: 'Today'),
                                ShowText(
                                  label: overviewModel == null
                                      ? ''
                                      : calculateValue(
                                          overviewModel!.lastDayData.energy),
                                  textStyle: MyConstant().h2Style(),
                                ),
                                const ShowText(label: ''),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const ShowText(label: 'This Mouth'),
                                ShowText(
                                  label: overviewModel == null
                                      ? ''
                                      : calculateValue(
                                          overviewModel!.lastMonthData.energy),
                                  textStyle: MyConstant().h2Style(),
                                ),
                                const ShowText(label: ''),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const ShowText(label: 'LifeTime'),
                                ShowText(
                                  label: overviewModel == null
                                      ? ''
                                      : calculateValue(
                                          overviewModel!.lifeTimeData.energy),
                                  textStyle: MyConstant().h2Style(),
                                ),
                                ShowText(
                                  label: overviewModel == null
                                      ? ''
                                      : calculateCurrecy(
                                          overviewModel!.lifeTimeData.revenue),
                                  textStyle: MyConstant().h3GreenStyle(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            }),
    );
  }

  Row newPowerLoadGrid(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ShowCard(
          size: constraints.maxWidth * 0.33,
          label: overviewModel == null
              ? ''
              : '${overviewModel!.currentPower.power} kW',
          pathImage: 'images/current.png',
        ),
        ShowCard(
          size: constraints.maxWidth * 0.33,
          label: siteCurrentPowerFlow == null
              ? ''
              : '${siteCurrentPowerFlow!.load.currentPower} ${siteCurrentPowerFlow!.unit}',
          pathImage: 'images/load.png',
        ),
        ShowCard(
          size: constraints.maxWidth * 0.33,
          label: siteCurrentPowerFlow == null
              ? ''
              : '${siteCurrentPowerFlow!.grid.currentPower} ${siteCurrentPowerFlow!.unit}',
          pathImage: 'images/grid.png',
        ),
      ],
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
                  SizedBox(
                    width: constraints.maxWidth * 0.6,
                    child: ShowText(
                      label: detailsModel!.name,
                      textStyle: MyConstant().h2WhiteStyle(),
                    ),
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

  String calculateValue(double energy) {
    String unit;
    String result;

    print('ค่าที่ต้องการจะแปลง ==>> $energy');

    double energyValue = energy;
    if (energyValue > 1000000) {
      unit = ' MWh';
      energyValue = energyValue / 1000000;
    } else if (energyValue > 1000) {
      unit = ' kWh';
      energyValue = energyValue / 1000;
    } else {
      unit = ' Wh';
    }

    NumberFormat numberFormat = NumberFormat('##0.0#', 'en_US');
    String string = numberFormat.format(energyValue);

    result = '$string $unit';

    return result;
  }

  String calculateCurrecy(double revenue) {
    String result;
    NumberFormat numberFormat = NumberFormat('#,###.#', 'en_US');
    String string = numberFormat.format(revenue);
    result = '฿ $string';
    return result;
  }
}
