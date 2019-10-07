import 'package:flutter/material.dart';
import 'package:workd/hoursCounter.dart';
import 'package:workd/weeksRoute.dart';
import 'package:workd/appTheme.dart';

void main() => runApp(Workd());

class Workd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

/// Sets up the app's scaffold
class HomeScreen extends StatelessWidget {
  void _toWeekRoute(BuildContext context) => Navigator.push(context,
      MaterialPageRoute(builder: (BuildContext context) => WeeksRoute()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: AppTheme.bgColor,
        title: Center(
          child: AppTheme.logo,
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () => _toWeekRoute(context),
              child: Icon(
                Icons.calendar_today,
                color: AppTheme.primary,
              ))
        ],
      ),
      body: HoursCounter(),
    );
  }
}
