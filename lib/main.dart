import 'package:flutter/material.dart';
import 'package:workd/appTheme.dart';
import 'package:workd/hoursCounter.dart';

void main() => runApp(Workd());

class Workd extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: AppTheme.bgColor,
          title: Center(
            child: AppTheme.logo,
          ),
        ),
        body: HoursCounter(),
      )
    );
  }
}