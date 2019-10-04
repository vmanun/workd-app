import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

/// Function that will write a new session into data.json 
void writeToJson(int totalHours) async {
  final file = await readFromJson();
  var newData =
      '{"date": "${DateTime.now().toString()}", "totalHours": "$totalHours"}';
  
  List<dynamic> currentData;
  currentData = file.existsSync() ? json.decode(file.readAsStringSync()) : [];
  currentData.add(json.decode(newData));
  file.writeAsString(json.encode(currentData));
}

/// Function that reads and returns the data file object
Future<File> readFromJson() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/data.json');
  if (await file.exists()) {
    final data = file.readAsStringSync();
    print(data);
  }
  return file;
}

/// Checks whether theres a session already done today
Future<bool> checkForSessionsToday() async {
  var today = DateTime.now();
  var file = await readFromJson();
  var currentData;
  
  if(file.existsSync()) {
    currentData = json.decode(file.readAsStringSync());

    for(var session in currentData) {
      final sessionDate = DateTime.parse(session['date']);
      if(today.day == sessionDate.day     && 
         today.month == sessionDate.month &&
         today.year == sessionDate.year) return true;
    }
  } 
  return false;
}

/// Overwrites today's session already registered with the newer session
void overwriteTodaySession(int totalHours) async {
  final file = await readFromJson();
  List<dynamic> currentData = json.decode(file.readAsStringSync());

  currentData.removeLast();
  file.writeAsStringSync(json.encode(currentData));
  writeToJson(totalHours);
}