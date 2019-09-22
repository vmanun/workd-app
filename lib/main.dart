import 'package:flutter/material.dart';
import 'package:workd/appTheme.dart';
import 'package:workd/hoursCounter.dart';

void main() => runApp(Workd());

class Workd extends StatelessWidget {
  final Widget logo = Container(
    width: 105.0,
    height: 50.0, 
    child: Center(child: Image.asset('assets/images/logo.png'))
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: AppTheme.bgColor,
          title: Center(
            child: logo,
          ),
        ),
        body: HoursCounter(),
      )
    );
  }
}