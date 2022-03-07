import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solacellanalysin/models/details_model.dart';
import 'package:solacellanalysin/utility/my_constant.dart';
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

  @override
  void initState() {
    super.initState();
    readData();
  }

  Future<void> readData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var datas = preferences.getStringList('data');
    // print('datas ==> $datas');

    String pathAPI =
        'https://monitoringapi.solaredge.com/site/${datas![0]}/details?api_key=${datas[1]}';
    await Dio().get(pathAPI).then((value) {
      // print('value ==> $value');
      Map<String, dynamic> map = value.data;
      var detailsMap = map['details'];
      // print('detailsMap ==> $detailsMap');

      setState(() {
        detailsModel = DetailsModel.fromMap(detailsMap);
        load = false;
        urlImage =
            'https://monitoringapi.solaredge.com${detailsModel!.uris.SITEIMAGE}?hash=123456789&api_key=${datas[1]}';
      });

      // print('name ==>> ${detailsModel.name}');
      // print('address ==> ${detailsModel.location.address}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? const ShowProgress()
          : LayoutBuilder(builder: (context, constraints) {
              return Container(
                width: constraints.maxWidth,
                height: 180,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(urlImage!), fit: BoxFit.cover)),
                child: Container(
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.5)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        ShowText(
                          label: detailsModel!.name,
                          textStyle: MyConstant().h2WhiteStyle(),
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
            }),
    );
  }
}
