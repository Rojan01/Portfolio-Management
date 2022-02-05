import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:portfolio_management/models/share_data.dart';
import 'models.dart';
import 'package:portfolio_management/services/data_service.dart';
import 'package:portfolio_management/utils/databasehelper.dart';
import 'package:http/http.dart' as http;


class ShareDataProvider extends ChangeNotifier {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<ShareData> _shareDataList = [];
  List<NepseShareDataModel> nepseDataList = [];
  DataService dataService = DataService();
  double _sum = 0;
  int _totalInvestment = 0;
  int _saveResult;
  int _deleteResult;

  ShareDataProvider() {
    getShareData();
  }

  void getShareData() async {
    final shareDataFromDBList = await databaseHelper.getShareDataList();
    _shareDataList = shareDataFromDBList;
    getTotalInvestment();
    getTotalProfitLoss();
    notifyListeners();
  }

  UnmodifiableListView<ShareData> get shareData {
    return UnmodifiableListView(_shareDataList);
  }

  int get shareDataCount {
    return _shareDataList.length;
  }

  Future<double> getPriceData(String companyName) async {
    nepseDataList = await dataService.fetchShareData(http.Client());
    double price;
    for (int i = 0; i < nepseDataList.length; i++)
      if (companyName == nepseDataList[i].companyName) {
        price = nepseDataList[i].closingPrice;
      }
    notifyListeners();
    return price;
  }

  Future<String> getPrice(String companyName) async {
    nepseDataList = await dataService.fetchShareData(http.Client());
    double price;
    for (int i = 0; i < nepseDataList.length; i++)
      if (companyName == nepseDataList[i].companyName) {
        price = nepseDataList[i].closingPrice;
      }
    return price.toString();
  }

  void getTotalProfitLoss() async {
    _sum = 0;
    _shareDataList = await databaseHelper.getShareDataList();
    for (int i = 0; i < _shareDataList.length; i++) {
      _sum += await getPriceData(_shareDataList[i].companyName) *
              _shareDataList[i].quantity -
          (_shareDataList[i].quantity * _shareDataList[i].price);
    }
    notifyListeners();
  }

  double get totalProfit {
    return _sum;
  }

  void getTotalInvestment() async {
    _totalInvestment = 0;
    _shareDataList = await databaseHelper.getShareDataList();
    for (int i = 0; i < _shareDataList.length; i++) {
      _totalInvestment = _totalInvestment +
          _shareDataList[i].quantity * _shareDataList[i].price;
    }
    notifyListeners();
  }

  String get totalInvestment {
    return _totalInvestment.toString();
  }

  void saveShareData(ShareData shareData) async {
    _saveResult = await databaseHelper.insertShareData(shareData);
    getShareData();
  }

  int get saveResult {
    return _saveResult;
  }

  void deleteShareData(int id) async {
    _deleteResult = await databaseHelper.deleteShareData(id);
    getShareData();
  }

  int get deleteResult {
    return _deleteResult;
  }
}

