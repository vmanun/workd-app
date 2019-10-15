import 'dart:async';
import 'package:flutter/material.dart';
import 'package:workd/appTheme.dart';
import 'package:workd/resultsView.dart';
import 'package:workd/manualHoursInput.dart';
import 'package:workd/hoursData.dart';

// TODO: The HoursCounter state needs some refactoring. Divide the counter from the first page
/// The main view of the app. Displays and activates
/// the counter when ready.
class HoursCounter extends StatefulWidget{
  HoursCounter();

  @override
  createState() => _HoursCounterState();
}

class _HoursCounterState extends State<HoursCounter> with AutomaticKeepAliveClientMixin {
  List<int>          _totalHours;
  bool               _isActive = false;
  bool               _isVisible;
  bool               _aSessionExistsToday;
  bool               _toManualInput = false;
  Stream<int>        _counter;
  StreamSubscription _counterListener;
  DateTime           _startTime;

  @override
  void initState() {
    super.initState();
    _totalHours = [0, 0];
    _isActive = false;
    updateKeepAlive();
    _isVisible = false;
    _toManualInput = false;
  }

  @override
  bool get wantKeepAlive => _isActive;

  ///Starts counting the hours
  void _startCounter() => setState(() {
        _isVisible = true;
        _startTime = DateTime.now();
        _counter = Stream.periodic(
            Duration(
              minutes: 1,
            ),
            (time) => time);
        _counterListener =
            _counter.listen((t) => setState(() {
              _totalHours[0] = DateTime.now().hour -_startTime.hour;
              _totalHours[1] = DateTime.now().minute -_startTime.minute;
            }));
        _fade(true);
      });

  ///stops and resets the counter state
  void _resetCounter() => setState(() {
        _isVisible = false;
        _startTime = null; 
        _counterListener.cancel();
        _counterListener = null;
        _counter = null;
        _totalHours[0] = 0;
        _totalHours[1] = 0;
        _fade(false);
      });

  ///stops and opens the results screen
  void _finishCounter() => setState(() {
        _isVisible = false;
        _totalHours[0] = DateTime.now().hour -_startTime.hour;
        _totalHours[1] = DateTime.now().minute -_startTime.minute;
        _fade(false);
        if (_totalHours[0] > 1)
          _toResultsRoute(false);
        else
          _toResultsRoute(true);
      });

  ///Opens the ResultsRoute widget via Navigator
  void _toResultsRoute(bool showError) async {
    if (!showError) {
      _counterListener.pause();
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ResultsView(
                [--_totalHours[0], _totalHours[1]],
              )));
    } else {
      _counterListener.pause();
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ResultsView([-1, -1])));
    }
    setState(() {
      _counterListener.cancel();
      _counterListener = null;
      _counter = null;
      _totalHours[0] = 0;
      _totalHours[1] = 0;
    });
  }

  void _toManualInputRoute(BuildContext context) {
    setState(() => _toManualInput = false);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => ManualHoursInput()));
  }
  

  ///A function that receives the visibility of the counter itself
  void _fade([bool value = true]) async => await Future.delayed(
      const Duration(milliseconds: 200),
      () => setState(() {
        _isActive = value;
        updateKeepAlive();
      }));

  ///The counter is ready to be displayed after pressing the BEGIN button
  Widget _counterReady() => AnimatedOpacity(
      opacity: !_isVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 200),
      child: Column(
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
                onPressed: () async {
                  final sessionExists = await checkForSessionsToday();
                  if (!sessionExists) _startCounter();
                  setState(() => _aSessionExistsToday = sessionExists);
                },
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
              )),
          MaterialButton(
            onPressed: () async {
              final sessionExists = await checkForSessionsToday();
              if (!sessionExists) _toManualInputRoute(context);
              setState(() {
                _aSessionExistsToday = sessionExists;
                _toManualInput = true;
                });
            },
            minWidth: 0.0,
            padding: EdgeInsets.symmetric(horizontal: 0.0),
            splashColor: AppTheme.splashColor,
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.secondary, width: 1.5),
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                margin: EdgeInsets.symmetric(horizontal: 0.0),
                width: 155.0,
                height: 55.0,
                child: Center(
                    child: Text(
                  'ADD A SESSION MANUALLY',
                  textAlign: TextAlign.center,
                  style: AppTheme.button,
                ))),
            ),
        ],
      ));

  /// Widget that displays the counting hours
  Widget _counterActive() => AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 200),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //The counter itself
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
                    '${_totalHours[0]}',
                    style: AppTheme.counterText,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'hours and',
                    textAlign: TextAlign.center,
                    style: AppTheme.headingOne,
                  ),
                  Text(
                    '${_totalHours[1]}',
                    style: AppTheme.counterText,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'mins',
                    textAlign: TextAlign.center,
                    style: AppTheme.headingOne,
                  ),
                ]),
            //FINISH button will call the _finishCounter function
            MaterialButton(
              onPressed: () => _finishCounter(),
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
            //CANCEL button will call the _resetCounter function
            MaterialButton(
              onPressed: () => _resetCounter(),
              minWidth: 0.0,
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              splashColor: AppTheme.splashColor,
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.secondary, width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 0.0),
                  width: 115.0,
                  height: 35.0,
                  child: Center(
                      child: Text(
                    'CANCEL',
                    textAlign: TextAlign.center,
                    style: AppTheme.button,
                  ))),
            ),
          ]));

  Widget _showDialog() {
    print('THERE IS A SESSION');
    return AlertDialog(
      content: Text(
        'There\'s already a session done today. Do you want to overwrite it?',
        style: AppTheme.dialog,
        textAlign: TextAlign.center,
      ),
      backgroundColor: AppTheme.bgColor,
      actions: <Widget>[
        FlatButton(
            onPressed: () => setState(() {
                _aSessionExistsToday = false;
                if(_toManualInput) _toManualInputRoute(context);
                else _startCounter();
              }),
            splashColor: AppTheme.splashColor,
            child: Text(
              'YES',
              textAlign: TextAlign.center,
              style: AppTheme.button,
            )),
        FlatButton(
            onPressed: () => setState(() => _aSessionExistsToday = false),
            splashColor: AppTheme.splashColor,
            child: Text(
              'NO',
              textAlign: TextAlign.center,
              style: AppTheme.button,
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _aSessionExistsToday != null && _aSessionExistsToday ? 
           _showDialog() : 
           _isActive ? _counterActive() : _counterReady();
  }
}
