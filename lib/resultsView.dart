import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workd/appTheme.dart';

class ResultsView extends StatelessWidget {

  final int totalHours;

  ResultsView(this.totalHours) { writeToJson(); readFromJson(); } 

  void writeToJson() async {
    final directory = await getApplicationDocumentsDirectory();
    var file = File('${directory.path}/data.json');
    var newData = '{"date": "${DateTime.now().toString()}", "totalHours": "$totalHours"}';
    List<dynamic> currentData = json.decode(file.readAsStringSync());
    currentData.add(json.decode(newData));
    file.writeAsString(json.encode(currentData), mode: FileMode.write);
  }

  void readFromJson() async {
    final directory = await getApplicationDocumentsDirectory();
    var file = File('${directory.path}/data.json'); 
    if(await file.exists()) {
      var data = file.readAsStringSync();
      print(data);
    }   
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
          )
      ),
      body: Center(
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
        )
      ),
    );
  }
} 