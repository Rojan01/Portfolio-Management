import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:portfolio_management/models/enum.dart';
import 'package:portfolio_management/models/share_data.dart';
import 'package:portfolio_management/models/share_data_provider.dart';
import 'package:portfolio_management/models/data_list.dart';
import 'package:provider/provider.dart';

class AddDetails extends StatefulWidget {
  @override
  _AddDetailsState createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  var companyNameController = TextEditingController();
  var scripNameController = TextEditingController();
  var quantityController = TextEditingController();
  var priceController = TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  var selectedMarket = Market.SECONDARY;
  List<String> scripNames = [];
  List<String> sectorNames = [];
  Map<String, String> scripCompanyName = ListDataModel.scripCompanyNameData;
  Map<String, String> companySectorName = ListDataModel.companySectorData;

  void getData() async {
    for (String key in scripCompanyName.keys) {
      scripNames.add(key);
    }
    for (String value in companySectorName.values) {
      sectorNames.add(value);
    }
  }

  String getSector(String companyName) {
    return companySectorName[companyName];
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Details'),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(5, 10, 5, 5),
        padding: EdgeInsets.all(5),
        child: ListView(
          children: [
            AutoCompleteTextField<String>(
              key: key,
              suggestions: scripNames,
              clearOnSubmit: false,
              decoration: InputDecoration(
                labelText: 'Enter Scrip',
                border: OutlineInputBorder(),
              ),
              textChanged: (text) {
                companyNameController.text =
                    scripCompanyName[scripNameController.text];
                return scripNameController.text = text;
              },
              itemFilter: (item, query) {
                return item.toLowerCase().contains(query.toLowerCase());
              },
              itemSorter: (a, b) {
                return a.compareTo(b);
              },
              itemSubmitted: (item) {
                setState(() {
                  scripNameController.text = item;
                  companyNameController.text =
                      scripCompanyName[scripNameController.text];
                });
              },
              itemBuilder: (context, item) {
                return suggestionBox(item);
              },
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: companyNameController,
              decoration: InputDecoration(
                labelText: 'Enter Company Name',
                border: OutlineInputBorder(),
              ),
            ),
            RadioListTile(
              title: Text('IPO'),
              value: Market.IPO,
              groupValue: selectedMarket,
              onChanged: (newValue) =>
                  setState(() => selectedMarket = newValue),
            ),
            RadioListTile(
              title: Text('Secondary'),
              value: Market.SECONDARY,
              groupValue: selectedMarket,
              onChanged: (newValue) =>
                  setState(() => selectedMarket = newValue),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: quantityController,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: TextField(
                    controller: priceController,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  ShareData shareData = ShareData(
                    scripNameController.text,
                    companyNameController.text,
                    int.parse(quantityController.text),
                    int.parse(priceController.text),
                    getSector(companyNameController.text),
                  );
                  print(shareData);
                  _save(shareData);
                });
              },
              child: Text(
                'ADD',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save(ShareData shareData) {
    Navigator.pop(context, true);
    Provider.of<ShareDataProvider>(context, listen: false)
        .saveShareData(shareData);
    int n = Provider.of<ShareDataProvider>(context, listen: false).saveResult;
    if (n != 0) {
      // Success
      AlertDialog alertDialog = AlertDialog(
        title: Text('Status'),
        content: Text('Added Successfully'),
      );
      showDialog(context: context, builder: (_) => alertDialog);
    } else {
      // Failure
      AlertDialog alertDialog = AlertDialog(
        title: Text('Status'),
        content: Text('Problem adding Data'),
      );
      showDialog(context: context, builder: (_) => alertDialog);
    }
  }

  Widget suggestionBox(String item) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
      child: Wrap(
        children: [
          Expanded(
            child: Text(
              item,
              maxLines: 2,
              style: TextStyle(fontSize: 14),
            ),
          )
        ],
      ),
    );
  }
}
