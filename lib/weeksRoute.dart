import 'package:flutter/material.dart';
import 'package:workd/appTheme.dart';
import 'package:workd/hoursData.dart';
import 'package:workd/resultsView.dart';

/// A widget that displays all the worked weeks as a ListView
class WeeksRoute extends StatefulWidget {
  WeeksRoute();

  @override
  createState() => WeeksRouteState();
}

class WeeksRouteState extends State {
  var _weeksData;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  /// Gets the data from data.json via the getWeeks() function
  void _getData() async {
    final data = await getWeeks();
    setState(() => _weeksData = data == null ? null : data);
  }

  /// Pushes a route via the navigator to a ResultsView instance with
  /// showWeekHours setted to true
  void _toResultsRoute(final week) {
    int totalHours = 0;

    for(var session in week) totalHours += int.parse(session['totalHours'], radix: 10);
    print('TOTAL HOURS (FROM WEEKS): $totalHours');

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ResultsView(
              totalHours,
              showWeekHours: true,
              sessions: week,
            )));
  }

  /// Prints all ordered weeks on console
  void printWeeks() => print(_weeksData);

  /// Creates a list of widgets with all the worked weeks registered.
  /// When one of those widgets is pressed, it pushes a route to ResultsView via
  /// the _toResultsRoute() function, passing along the way to selected week
  /// sessions of the which are going to be displayed.
  List<Widget> _listWeeks() {
    List<Widget> result = [];

    for (var week in _weeksData) {
      Map<String, DateTime> weekLimits = {
        'start': getWeekStart(DateTime.parse(week[0]['date'])),
        'end': getWeekEnd(DateTime.parse(week[0]['date']))
      };

      // String variables made for formatting
      var weekStart = '${weekLimits['start'].day}/${weekLimits['start'].month}/${weekLimits['start'].year}';
      var weekEnd = '${weekLimits['end'].day}/${weekLimits['end'].month}/${weekLimits['end'].year}';

      result.add(
        InkWell(
          onTap: () => _toResultsRoute(week),
          splashColor: AppTheme.splashColor,
          highlightColor: AppTheme.secondaryBgColor,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Text(
              'Week $weekStart - $weekEnd',
              style: AppTheme.dialog,
              textAlign: TextAlign.start,
            ),
          )
        )
      );
    }
    return result;
  }

  /// Returns a ListView with all the given weeks (via _listWeeks())
  Widget _weeksList() {
    return ListView(
          padding: EdgeInsets.all(5.0),
          children: _listWeeks(),
    );
  }

  /// Returns a widget with an error message if no work sessions have been registered yet
  Widget _showError() {
    return Center(
      child: Text(
        'There\'s no data to display.',
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
            'Week Data',
            textAlign: TextAlign.start,
            style: AppTheme.headingOne,
          )),
      body: Material(
        child: _weeksData == null ?_showError() : _weeksList()
      )
    );    
  }
}
