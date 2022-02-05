import 'package:flutter/material.dart';
import 'package:portfolio_management/models/share_data.dart';
import 'package:portfolio_management/models/share_data_provider.dart';
import 'package:provider/provider.dart';


class ShareDetails extends StatefulWidget {
  final ShareData shareData;
  final Future<String> ltp;
  ShareDetails({this.shareData, this.ltp});
  @override
  _ShareDetailsState createState() => _ShareDetailsState(shareData, ltp);
}

class _ShareDetailsState extends State<ShareDetails> {
  ShareData shareData;
  Future<String> ltp;
  _ShareDetailsState(this.shareData, this.ltp);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shareData.companyName),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                _delete();
              },
              child: Icon(
                Icons.delete,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Colors.lightBlueAccent,
              Colors.blueAccent,
            ],
          ),
        ),
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text('Total Units'),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          shareData.quantity.toString(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text('WACC'),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Rs. 315.6'),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text('Total Investment'),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          (shareData.quantity * shareData.price).toString(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text('LTP'),
                        SizedBox(
                          height: 5,
                        ),
                        FutureBuilder<String>(
                          future: ltp, // async work
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              default:
                                if (snapshot.hasError)
                                  return Text('Error');
                                else
                                  return Text(snapshot.data);
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text('Total +/-'),
                        SizedBox(
                          height: 5,
                        ),
                        FutureBuilder<String>(
                          future: ltp, // async work
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              default:
                                if (snapshot.hasError)
                                  return Text('Error');
                                else
                                  return Text(
                                    (double.parse(snapshot.data) *
                                                shareData.quantity -
                                            (shareData.quantity *
                                                shareData.price))
                                        .toString(),
                                  );
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text('Today\'s Profit'),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Rs.120'),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _delete() async {
    Navigator.pop(context, true);
    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of ShareDataList page.
    if (shareData.id == null) {
      _showAlertDialog('Status', 'No Data was deleted');
      return;
    }
    // Case 2: User is trying to delete the old note that already has a valid ID.
    Provider.of<ShareDataProvider>(context, listen: false)
        .deleteShareData(shareData.id);
    int result =
        Provider.of<ShareDataProvider>(context, listen: false).deleteResult;
    if (result != 0) {
      _showAlertDialog('Status', 'Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}