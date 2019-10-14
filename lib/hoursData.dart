import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

/// Function that will write a new session into data.json 
void writeToJson(List<int> totalHours) async {
  final file = await overwriteTodaySession();
  var newData =
      '{"date": "${DateTime.now().toString()}", "totalHours": ["${totalHours[0]}", "${totalHours[1]}"]}';
  
  List<dynamic> currentData;
  currentData = file.existsSync() ? json.decode(file.readAsStringSync()) : [];
  currentData.add(json.decode(newData));
  file.writeAsString(json.encode(currentData));
  print('DATA: $currentData');

}

/// Function that reads and returns the data file object
Future<File> readFromJson() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/data.json');
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
      if(today.day   == sessionDate.day   && 
         today.month == sessionDate.month &&
         today.year  == sessionDate.year) return true;
    }
  } 
  return false;
}

/// Overwrites today's session already registered with the newer session
/// only if there's already a session registered on the given day
Future<File> overwriteTodaySession() async {
  final file = await readFromJson();
  List<dynamic> currentData = file.existsSync() ? json.decode(file.readAsStringSync()) : null;

  if(await checkForSessionsToday()) {
    currentData.removeLast();
    file.writeAsStringSync(json.encode(currentData));
  }

  return file;
}

// void writeWeeks() async {
//   final File file = await readFromJson();
  
//   file.writeAsStringSync('[{"date":"2019-09-01 10:00:00.000000","totalHours":"2"},{"date":"2019-09-02 10:00:00.000000","totalHours":"3"},{"date":"2019-09-03 10:00:00.000000","totalHours":"4"}, {"date":"2019-09-04 10:00:00.000000","totalHours":"12"}, {"date":"2019-09-05 10:00:00.000000","totalHours":"5"}, {"date":"2019-09-06 10:00:00.000000","totalHours":"5"}, {"date":"2019-09-07 10:00:00.000000","totalHours":"5"}, {"date":"2019-09-08 10:00:00.000000","totalHours":"5"}, {"date":"2019-09-09 10:00:00.000000","totalHours":"5"}, {"date":"2019-09-10 10:00:00.000000","totalHours":"5"}, {"date":"2019-09-13 10:00:00.000000","totalHours":"11"},{"date":"2019-09-14 10:00:00.000000","totalHours":"10"},{"date":"2019-09-20 10:00:00.000000","totalHours":"12"}]');
// }

/// returns the beginning week day of a certain date as a DateTime
/// if startOnMonday is set to true, it'll take monday as the starting
/// day of a week
DateTime getWeekStart(DateTime date, {startOnMonday = true}) {
  return startOnMonday ? DateTime(date.year, date.month, date.day - (date.weekday - 1)) :
        DateTime(date.year, date.month, date.day - (date.weekday));
}

/// returns the week's ending day of a given date as a DateTime
DateTime getWeekEnd(DateTime date) => DateTime(
  date.year, 
  date.month, 
  date.day + 
  (7 - date.weekday));

/// Fetchs all data from data.json, and separates it into Lists, each representing
/// a week of work sessions
Future<List<dynamic>> getWeeks() async {
  final File file = await readFromJson();
  final currentData = file.existsSync() ? json.decode(file.readAsStringSync()) : null;
  List<List<dynamic>> result = [[]];


  if(currentData != null) {
    var lastWeekStart;
    var resultIndex = 0;
    lastWeekStart = getWeekStart(DateTime.parse(currentData[0]['date']));
  
    for(var session in currentData) {
      var sessionDate = DateTime.parse(session['date']);
      var sessionWeekStart = getWeekStart(sessionDate);

      if(sessionWeekStart.day  == lastWeekStart.day   &&
        sessionWeekStart.month == lastWeekStart.month &&
        sessionWeekStart.year  == lastWeekStart.year) {
          print(sessionWeekStart.day  == lastWeekStart.day && sessionWeekStart.month == lastWeekStart.month && sessionWeekStart.year  == lastWeekStart.year);
          result[resultIndex].add(session);
      } else {
        result.add([session]);
        resultIndex++;
        lastWeekStart = sessionWeekStart;
      }
    }

    return result;
  }

  return null;
}