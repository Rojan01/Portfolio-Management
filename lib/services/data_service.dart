import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:portfolio_management/models/models.dart';

const nepseApiURL = 'https://nepse-data-api.herokuapp.com/data/todaysprice';
// const nepseApiURL =
//     'https://newweb.nepalstock.com/api/nots/nepse-data/today-price?size=300';

class DataService {
  // ignore: missing_return
  Future<List<NepseShareDataModel>> fetchShareData(http.Client client) async {
    final response = await client.get(Uri.parse(nepseApiURL));
    try {
      if (response.statusCode == 200) {
        final parsed =
            await json.decode(response.body).cast<Map<String, dynamic>>();
        return parsed
            .map<NepseShareDataModel>(
                (json) => NepseShareDataModel.fromJson(json))
            .toList();
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
  }
}
