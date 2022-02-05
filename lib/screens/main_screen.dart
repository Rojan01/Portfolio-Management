import 'package:flutter/material.dart';
import 'package:portfolio_management/models/share_data_provider.dart';
import 'dashboard.dart';
import 'package:provider/provider.dart';
import 'package:portfolio_management/widgets/pie_chart.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Portfolio Management'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Colors.greenAccent,
              Colors.lightGreen,
            ],
          ),
        ),
        child: ListView(
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: Text(
                'My Portfolio',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      myStocksCard(
                        'Number of Total Stocks',
                        '${Provider.of<ShareDataProvider>(context).shareDataCount == 0 ? 'You do not hold any stock.' : Provider.of<ShareDataProvider>(context).shareDataCount}',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PieChartWidget(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Card(
                    color: Colors.lime[100],
                    child: ListTile(
                      leading: Text('Total Investment'),
                      title: Text(
                          '${Provider.of<ShareDataProvider>(context).totalInvestment == '0' ? 'You do not have any investements.' : 'Rs. ${Provider.of<ShareDataProvider>(context).totalInvestment}'}'),
                    ),
                  ),
                  Card(
                    color: Colors.lime[100],
                    child: ListTile(
                      leading: Text('Total Profit'),
                      title: Text(
                          '${Provider.of<ShareDataProvider>(context).totalInvestment == '0' ? 'You do not have any investements.' : 'Rs. ${Provider.of<ShareDataProvider>(context).totalProfit}'}'),
                    ),
                  ),
                  Container(
                    height: 300,
                    margin: EdgeInsets.only(top: 24),
                    child: ListView.builder(
                      itemCount:
                          Provider.of<ShareDataProvider>(context, listen: false)
                              .shareData
                              .length,
                      itemBuilder: (context, index) {
                        var shareLists = Provider.of<ShareDataProvider>(context,
                                listen: false)
                            .shareData
                            .toList();
                        return ListTile(
                          leading: Text('${shareLists[index].scrip}'),
                          title: Text('${shareLists[index].companyName}'),
                          trailing: Text('${shareLists[index].quantity} units'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DashBoard(),
            ),
          );
        },
        label: const Text('Add Stocks'),
        icon: const Icon(Icons.ad_units),
        backgroundColor: Colors.lime,
      ),
    );
  }

  Widget myStocksCard(String heading, String value, Function onClick) {
    return Expanded(
      child: Card(
        color: Colors.lime[100],
        elevation: 5,
        margin: EdgeInsets.all(15),
        child: InkWell(
          onTap: onClick,
          splashColor: Colors.greenAccent,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    heading,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  value == "0.0"
                      ? SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                            backgroundColor: Colors.red,
                          ),
                        )
                      : Text('$value')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
