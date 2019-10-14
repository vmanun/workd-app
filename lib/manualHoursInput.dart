import 'package:flutter/material.dart';
import 'package:workd/appTheme.dart';
import 'package:workd/resultsView.dart';

/// A view that lets the user input the worked hours
/// manually (from a given starting time and finishing time)
class ManualHoursInput extends StatefulWidget {
  ManualHoursInput();

  @override
  createState() => _ManualHoursInputState();
}

class _ManualHoursInputState extends State<ManualHoursInput>  {
  TimeOfDay _startingTime;
  TimeOfDay _finishingTime;

  /// Same method as seen in the hoursCounter view; it display the
  /// total hours via the ResultsView widget
  void _toResultsRoute(bool showError, List<int> totalHours) async {
    if (!showError) {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ResultsView(
                [--totalHours[0], totalHours[1]],
              )));
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ResultsView([-1, -1])));
    }
  }

  /// Time selector widget from which the user will input the
  /// both the starting and finishing time (depending on whether the 
  /// showStartTimePicker is true or not)
  Widget _timeSelector(bool showStartTimePicker) {
    final String emptyTime = '   --   :   --   :   --   ';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '${showStartTimePicker ? 'Starting' : 'Finishing'} time:',
          style: AppTheme.dialog,
          textAlign: TextAlign.left,
        ),
        FlatButton(
          onPressed: () async {
            Future<TimeOfDay> timeInput = showTimePicker(
              initialTime: showStartTimePicker 
                  ? _startingTime != null ? _startingTime : TimeOfDay.now()
                  :_finishingTime != null ? _finishingTime : TimeOfDay.now(),
              context: context,
            );
            final selectedTime = await timeInput;
            if(showStartTimePicker) {
              if(_startingTime == null && selectedTime != null) _startingTime = selectedTime;
              setState(() {
                _startingTime = _startingTime;
                  if(_finishingTime != null && _startingTime != null) 
                    if(_startingTime.hour > _finishingTime.hour)
                      if(_startingTime.minute > _finishingTime.minute)
                        _startingTime = null;
              }); 
            } else {
              if(_finishingTime == null && selectedTime != null) _finishingTime = selectedTime;
              setState(() {
                _finishingTime = _finishingTime;
                  if(_finishingTime != null && _startingTime != null) 
                    if(_finishingTime.hour < _startingTime.hour)
                      if(_finishingTime.minute < _startingTime.minute)
                        _finishingTime = null;
              }); 
            }
          },
          color: AppTheme.secondaryBgColor,
          child: showStartTimePicker ? 
            Text(
              '${_startingTime != null ? "   ${_startingTime.hour > 12 ? _startingTime.hour - 12 : _startingTime.hour}   :   ${_startingTime.minute < 10 ? '0${_startingTime.minute}' : _startingTime.minute}  ${_startingTime.period == DayPeriod.am ? 'AM' : 'PM'}" : emptyTime}',
            ) :
            Text(
              '${_finishingTime != null ? "   ${_finishingTime.hour > 12 ? _finishingTime.hour - 12 : _finishingTime.hour}   :   ${_finishingTime.minute < 10 ? '0${_finishingTime.minute}' : _finishingTime.minute}  ${_finishingTime.period == DayPeriod.am ? 'AM' : 'PM'}" : emptyTime}',
            ),
        )
      ],
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
            'Manual Hours Input',
            textAlign: TextAlign.start,
            style: AppTheme.headingOne,
          )),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 150.0),
          child: Column(
            children: <Widget>[
              _timeSelector(true),
              _timeSelector(false),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30.0),
                child: MaterialButton(
                  onPressed: (){
                    final result = DateTime(1, 1, 1, _finishingTime.hour, _finishingTime.minute).difference(DateTime(1, 1, 1, _startingTime.hour, _startingTime.minute));
                    final List<int> totalHours = [result.inHours, int.parse('${(result.inMinutes)-(result.inHours * 60)}'.split('.')[0], radix: 10)];
                    print(totalHours);

                    if(totalHours[0] <= 1) _toResultsRoute(true, totalHours);
                    else _toResultsRoute(false, totalHours);
                  },
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
                ),
              )
            ],
          )
        ),
      )
    );
  }
}