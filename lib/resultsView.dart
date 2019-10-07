import 'package:flutter/material.dart';
import 'package:workd/appTheme.dart';
import 'package:workd/hoursData.dart';

/// Display both results for the session of the day nd the weeks' sessions
class ResultsView extends StatelessWidget {
  final int totalHours;
  final bool showWeekHours;
  final List<dynamic> sessions;

  ResultsView(this.totalHours, {this.showWeekHours = false, this.sessions}) {
    // -1 represents the totalHours being 0 or 1 hours. It has to be more thn one
    // showWeekHours is the handler that turns this widget from today's sesion
    // to the whole week's sessions
    if(totalHours != -1 && !showWeekHours) {
      writeToJson(totalHours);
    }
    readFromJson();
  }
  /// Function that returns a Column widget with all the given week's sessions, or an empty Text if
  /// showWeekHours is false
  Widget _showSessions() {
    List<Widget> sessionList = [];

    if(sessions != null){
      for(var session in sessions) {
        var sessionDate = DateTime.parse(session['date']);
        sessionList.add(
        Text(
            '${sessionDate.day}/${sessionDate.month}/${sessionDate.year}: ${session['totalHours']} hours',
            style: AppTheme.dialogLight,
          )
        );
      }
    }

    return showWeekHours ? Column(
      children: <Widget>[
        Divider(height: 20.0),
        Text('Sessions',
          style: AppTheme.dialog,
        ),
        Column(
          children: sessionList,
        )
      ],
    ) : Text('');
  }
  /// Returns the results: If showWeekHours is true, it displays the given week's
  /// sessions (taken from the variable with that exact name); else, it will display
  /// today's total worked hours. 
  Widget _showResults() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          '${showWeekHours ? 'This week' : 'Today'}, you\'ve worked for:',
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
        ),
        _showSessions()
      ],
    ));
  }

  /// Displays an error message, saying that the total hours must be at least
  /// 1. Can be generalized if needed to display any post-hour-counting errors.
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
            '${showWeekHours ? 'This Week' : 'Today'}\'s Results',
            textAlign: TextAlign.start,
            style: AppTheme.headingOne,
          )),
      body: totalHours == -1 ? _showError() : _showResults(),
    );
  }
}
