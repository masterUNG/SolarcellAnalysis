// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solacellanalysin/models/banner_model.dart';
import 'package:solacellanalysin/models/details_model.dart';
import 'package:solacellanalysin/models/env_benefits_model.dart';
import 'package:solacellanalysin/models/menu_model.dart';
import 'package:solacellanalysin/models/overview_model.dart';
import 'package:solacellanalysin/models/site_current_power_flow_model.dart';
import 'package:solacellanalysin/models/site_model.dart';
import 'package:solacellanalysin/states/check_pin_code.dart';
import 'package:solacellanalysin/utility/my_constant.dart';
import 'package:solacellanalysin/utility/my_dialog.dart';
import 'package:solacellanalysin/widgets/show_card.dart';
import 'package:solacellanalysin/widgets/show_imge.dart';
import 'package:solacellanalysin/widgets/show_progress.dart';
import 'package:solacellanalysin/widgets/show_text.dart';
import 'package:url_launcher/url_launcher.dart';

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
  ];
  var pathRounts = <String>[
    MyConstant.routeSiteDetails,
    '',
    MyConstant.routeAbout,
  ];

  var menuModels = <MenuModel>[];
  var chooseMenu;
  EnvBenefitsModel? envBenefitsModel;

  OverviewModel? overviewModel;
  SiteCurrentPowerFlow? siteCurrentPowerFlow;
  var datas = <String>[];
  SiteModel? siteModel;
  BannerModel? lastesBannerModel;

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
    datas = preferences.getStringList('data')!;

    // for Read Banner
    await FirebaseFirestore.instance
        .collection('banner')
        .orderBy('dateAdd', descending: true)
        .get()
        .then((value) {
      bool status = true;
      for (var item in value.docs) {
        print('#17mar item Banner ==>> ${item.data()}');
        if (status) {
          lastesBannerModel = BannerModel.fromMap(item.data());
          status = false;
        }
      }
    });

    // for Read Details
    String pathAPI =
        'https://monitoringapi.solaredge.com/site/${datas[0]}/details?api_key=${datas[1]}';
    await Dio().get(pathAPI).then((value) {
      Map<String, dynamic> map = value.data;
      var detailsMap = map['details'];

      setState(() {
        detailsModel = DetailsModel.fromMap(detailsMap);

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
      print('#17mar reslut CurrentPowerFlow ==>> $result');
      setState(() {
        siteCurrentPowerFlow = SiteCurrentPowerFlow.fromMap(result);
      });
    });

    // for SiteModel
    await FirebaseFirestore.instance
        .collection('site')
        .doc(datas[0])
        .get()
        .then((value) {
      siteModel = SiteModel.fromMap(value.data()!);
    });

    // for envBenefits
    String pathEnvBenefits =
        'https://monitoringapi.solaredge.com/site/${datas[0]}/envBenefits?api_key=${datas[1]}';
    await Dio().get(pathEnvBenefits).then((value) {
      print('#17mar value EnvBenefits ==>> $value');
      Map<String, dynamic> envBenefitsMap = value.data['envBenefits'];
      print('#17mar envBenefitsMap ==>>> $envBenefitsMap');
      setState(() {
        load = false;
        envBenefitsModel = EnvBenefitsModel.fromMap(envBenefitsMap);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? const ShowProgress()
          : LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    newInforTop(constraints),
                    newPowerLoadGrid(constraints),
                    newPowerFlow(constraints),
                    newBanner(constraints),
                    newMaintenance(
                        constraints: constraints,
                        path: 'images/manten1.png',
                        label: 'Maintenance 1',
                        timestamp: siteModel!.mainten1),
                    newMaintenance(
                        constraints: constraints,
                        path: 'images/manten2.png',
                        label: 'Maintenance 2',
                        timestamp: siteModel!.mainten2),
                    newMaintenance(
                        constraints: constraints,
                        path: 'images/manten3.png',
                        label: 'Maintenance 3',
                        timestamp: siteModel!.mainten3),
                    newEnvBenefits(
                        constraints: constraints,
                        path: 'images/co2.png',
                        label: 'CO2 Emission Saved',
                        value: envBenefitsModel!.gasEmissionSaved.co2,
                        units: envBenefitsModel!.gasEmissionSaved.units),
                    newEnvBenefits(
                      constraints: constraints,
                      path: 'images/tree.png',
                      label: 'Equivalent Trees Planted',
                      value: envBenefitsModel!.treesPlanted,
                    ),
                  ],
                ),
              );
            }),
    );
  }

  Widget newBanner(BoxConstraints constraints) {
    return InkWell(
      onTap: () {
        gotoUrl();
      },
      child: SizedBox(
        width: constraints.maxWidth,
        child: lastesBannerModel == null
            ? const ShowProgress()
            : Image.network(lastesBannerModel!.pathBanner),
      ),
    );
  }

  Card newEnvBenefits({
    required BoxConstraints constraints,
    required String path,
    required String label,
    required double value,
    String? units,
  }) {
    String valueString = '';
    if (envBenefitsModel != null) {
      NumberFormat format = NumberFormat('#,###.##', 'en_US');
      valueString = format.format(value);
      if (units != null) {
        valueString = '$valueString $units';
      }
    }

    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: constraints.maxWidth * 0.75,
            child: ListTile(
              leading: ShowImage(
                path: path,
              ),
              title: ShowText(label: label),
              subtitle: ShowText(
                label: envBenefitsModel == null ? '' : valueString,
                textStyle: MyConstant().h3GreenStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Card newMaintenance({
    required BoxConstraints constraints,
    required String path,
    required String label,
    required Timestamp timestamp,
  }) {
    String dateString = 'dd / MMM / yyyy';
    DateFormat dateFormat = DateFormat('dd MMM yyyy');
    dateString = dateFormat.format(timestamp.toDate());

    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: constraints.maxWidth * 0.75,
            child: ListTile(
              leading: ShowImage(
                path: path,
              ),
              title: ShowText(label: label),
              subtitle: ShowText(
                label: dateString,
                textStyle: MyConstant().h3GreenStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox newPowerFlow(BoxConstraints constraints) {
    return SizedBox(
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
                        : calculateValue(overviewModel!.lastDayData.energy),
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
                        : calculateValue(overviewModel!.lastMonthData.energy),
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
                        : calculateValue(overviewModel!.lifeTimeData.energy),
                    textStyle: MyConstant().h2Style(),
                  ),
                  ShowText(
                    label: overviewModel == null
                        ? ''
                        : calculateCurrecy(overviewModel!.lifeTimeData.revenue),
                    textStyle: MyConstant().h3GreenStyle(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget newPowerLoadGrid(BoxConstraints constraints) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ShowCard(
              size: constraints.maxWidth * 0.33,
              label: siteCurrentPowerFlow == null
                  ? ''
                  : '${siteCurrentPowerFlow!.pv.currentPower} kW',
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
        ),
        Positioned(
          top: constraints.maxWidth * 0.33 * 0.5 - 8,
          left: constraints.maxWidth * 0.33 - 8,
          child: const Icon(
            Icons.arrow_forward,
            color: Colors.green,
          ),
        ),
        Positioned(
          top: constraints.maxWidth * 0.33 * 0.5 - 8,
          right: constraints.maxWidth * 0.33 - 8,
          child: const Icon(
            Icons.arrow_back,
            color: Colors.orange,
          ),
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
          Navigator.pushNamed(context, menuModel.pathRoute);
        } else {
          switch (menuModel.title) {
            case 'Settings':
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckPinCode(
                      siteModel: siteModel!,
                      siteId: datas[0],
                      setting: true,
                    ),
                  ));
              break;
            default:
          }
        }
      });

  String calculateValue(double energy) {
    String unit;
    String result;

    print('????????????????????????????????????????????????????????? ==>> $energy');

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
    result = '??? $string';
    return result;
  }

  Future<void> gotoUrl() async {
    if (await canLaunch(lastesBannerModel!.pathUrl)) {
      await launch(lastesBannerModel!.pathUrl);
    } else {
      MyDialog(context: context).normalDialog(
          title: 'Banner False', message: 'Please Try Again Next Time');
    }
  }
}
