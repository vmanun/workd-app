import 'package:flutter/material.dart';
import 'package:workd/appTheme.dart';

class HoursCounter extends StatefulWidget {
  HoursCounter();

  @override
  createState() => _HoursCounterState();
}

class _HoursCounterState extends State<HoursCounter> {
  static int hoursWorked = 0;
  final Widget counterReady = Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Text(
        'The counter is ready. Please press "begin" to start counting your hours.',
        textAlign: TextAlign.center,
        style: AppTheme.headingOne,
      ),
      Padding(
          padding: EdgeInsets.all(20.0),
          child: MaterialButton(
            onPressed: () {},
            color: AppTheme.secondaryBgColor,
            splashColor: AppTheme.splashColor,
            child: Container(
                width: 85.0,
                height: 35.0,
                child: Center(
                    child: Text(
                  'BEGIN',
                  textAlign: TextAlign.center,
                  style: AppTheme.button,
                ))),
          ))
    ],
  );

  final Widget counterActive = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            child: Text(
          'You\'ve been working for:',
          textAlign: TextAlign.center,
          style: AppTheme.headingOne,
        )),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '$hoursWorked',
                style: AppTheme.counterText,
                textAlign: TextAlign.center,
              ),
              Text(
                'hours',
                textAlign: TextAlign.center,
                style: AppTheme.headingOne,
              ),
            ]),
        MaterialButton(
          onPressed: () {},
          color: AppTheme.secondaryBgColor,
          splashColor: AppTheme.splashColor,
          child: Container(
              width: 85.0,
              height: 35.0,
              child: Center(
                  child: Text(
                'FINISH',
                textAlign: TextAlign.center,
                style: AppTheme.button,
              ))),
        )
      ]);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: counterActive,
    );
  }
}
