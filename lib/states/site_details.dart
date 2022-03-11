import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solacellanalysin/models/details_model.dart';
import 'package:solacellanalysin/utility/my_constant.dart';
import 'package:solacellanalysin/widgets/show_progress.dart';
import 'package:solacellanalysin/widgets/show_text.dart';

class SiteDetail extends StatefulWidget {
  const SiteDetail({Key? key}) : super(key: key);

  @override
  State<SiteDetail> createState() => _SiteDetailState();
}

class _SiteDetailState extends State<SiteDetail> {
  String? idSite, tokenAPI;
  bool load = true;
  DetailsModel? detailsModel;

  String? urlImage;

  @override
  void initState() {
    super.initState();
    readDetail();
  }

  Future<void> readDetail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var datas = preferences.getStringList('data');

    String pathAPIdetail =
        'https://monitoringapi.solaredge.com/site/${datas![0]}/details?api_key=${datas[1]}';
    await Dio().get(pathAPIdetail).then((value) {
      load = false;
      Map<String, dynamic> map = value.data;
      detailsModel = DetailsModel.fromMap(map['details']);
      urlImage =
          'https://monitoringapi.solaredge.com${detailsModel!.uris.SITEIMAGE}?hash=123456789&api_key=${datas[1]}';
      print('name ==>> ${detailsModel!.name}');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(detailsModel == null ? '' : detailsModel!.name),
      ),
      body: load
          ? const ShowProgress()
          : LayoutBuilder(builder: (context, constraints) {
              return newListView(constraints);
            }),
    );
  }

  Widget newListView(BoxConstraints constraints) => ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          showImage(constraints),
          createWidgetCheckBox('Status', detailsModel!.status),
          newDivider(),
          createWidget('ID', detailsModel!.id.toString(), constraints),
          newDivider(),
          createWidget('Name', detailsModel!.name, constraints),
          newDivider(),
          createWidget('Address', detailsModel!.location.address, constraints),
          newDivider(),
          createWidget(
              'Installed',
              processFormatDateTime(detailsModel!.installationDate),
              constraints),
          newDivider(),
           createWidget(
              'Last Updated',
              processFormatDateTime(detailsModel!.lastUpdateTime),
              constraints),
          newDivider(),
          createWidget('Peak Power', '${detailsModel!.peakPower} kWp', constraints),
          newDivider(),
        ],
      );

  Divider newDivider() => const Divider(
        color: Colors.grey,
      );

  Container showImage(BoxConstraints constraints) {
    return Container(
      padding: const EdgeInsets.all(36),
      width: constraints.maxWidth,
      height: constraints.maxWidth,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(urlImage!), fit: BoxFit.contain)),
    );
  }

  Widget createWidgetCheckBox(String title, String detail) {
    Widget widget;

    if (detail == 'Active') {
      widget = const Icon(
        Icons.check_circle_rounded,
        color: Colors.green,
      );
    } else {
      widget = const Icon(
        Icons.remove_circle,
        color: Colors.red,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ShowText(label: title),
          widget,
        ],
      ),
    );
  }

  Widget createWidget(
          String title, String detail, BoxConstraints constraints) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShowText(label: title),
            Container(
              alignment: Alignment.topRight,
              width: constraints.maxWidth * 0.6,
              child: ShowText(
                label: detail,
                textStyle: MyConstant().h2Style(),
              ),
            )
          ],
        ),
      );

  String processFormatDateTime(String installationDate) {
    var strings = installationDate.split('-');
    return '${strings[2]}/${strings[1]}/${strings[0]}';
  }
}
