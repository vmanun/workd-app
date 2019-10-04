import 'package:flutter/material.dart';
import 'package:workd/appTheme.dart';
import 'package:workd/hoursData.dart';

class ResultsView extends StatelessWidget {
  final int totalHours;

  ResultsView(this.totalHours, {bool overwriteSession = false}) {
    if(totalHours != -1) {
      if(!overwriteSession) writeToJson(totalHours);
      else overwriteTodaySession(totalHours);
    }
    readFromJson();
  }

  Widget _showResults() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Today, you\'ve worked for:',
          style: AppTheme.headingOne,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '$totalHours',
              style: AppTheme.counterText,
              textAlign: TextAlign.center,
            ),
            Text(
              'hours',
              style: AppTheme.headingOne,
              textAlign: TextAlign.center,
            )
          ],
        )
      ],
    ));
  }

  Widget _showError() {
    return Center(
      child: Text(
        'You\'ve worked for less than 1 hour, your hours won\'t be registered.',
        style: AppTheme.headingOne,
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: AppTheme.bgColor,
          iconTheme: IconThemeData(color: AppTheme.secondary),
          title: Text(
            'Today\'s Results',
            textAlign: TextAlign.start,
            style: AppTheme.headingOne,
          )),
      body: totalHours == -1 ? _showError() : _showResults(),
    );
  }
}
