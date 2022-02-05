import 'package:flutter/material.dart';
import 'package:portfolio_management/models/share_data.dart';
import 'package:portfolio_management/models/share_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartWidget extends StatefulWidget {
  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  Map<String, double> dataMap = Map<String, double>();
  List<ShareData> shareDataList = [];
  List<Color> colorList = [
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.redAccent,
    Colors.blueGrey,
    Colors.purple,
    Colors.black12,
    Colors.greenAccent,
    Colors.pink,
  ];

  void getDataMap() {
    shareDataList =
        Provider.of<ShareDataProvider>(context, listen: false).shareData;
    if (shareDataList.length == 0) {
      dataMap.addAll({'null': 1});
    } else {
      for (int i = 0; i < shareDataList.length; i++) {
        if (!dataMap.containsKey('${shareDataList[i].sectorName}')) {
          dataMap.addAll({'${shareDataList[i].sectorName}': 1.0});
        } else {
          dataMap.update('${shareDataList[i].sectorName}',
              (value) => dataMap['${shareDataList[i].sectorName}'] + 1.0);
          print(dataMap['${shareDataList[i].sectorName}']);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getDataMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PieChart'),
      ),
      body: PieChart(
        dataMap: dataMap,
        initialAngleInDegree: 0,
        animationDuration: Duration(milliseconds: 800),
        chartType: ChartType.disc,
        chartRadius: MediaQuery.of(context).size.width / 2.2,
        ringStrokeWidth: 32,
        colorList: colorList,
        chartLegendSpacing: 20,
        centerText: "Stocks",
        legendOptions: LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendShape: BoxShape.circle,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 8,
            color: Colors.black87,
          ),
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: false,
          showChartValuesInPercentage: true,
          showChartValuesOutside: false,
          decimalPlaces: 1,
        ),
      ),
    );
  }
}