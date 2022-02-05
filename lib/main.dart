import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:portfolio_management/screens/main_screen.dart';
import 'package:portfolio_management/models/share_data_provider.dart';


void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ShareDataProvider(),
      child: MaterialApp(
        title: 'Mero Share Portfolio',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.lime,
        ),
        home: MainScreen(),
      ),
    );
  }
}
