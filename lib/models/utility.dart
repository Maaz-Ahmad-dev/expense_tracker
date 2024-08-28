import 'package:expense_tracker/models/add_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

int totals = 0;

final box = Hive.box<AddData>('data');

int total() {
  var dataList = box.values.toList();
  List a = [0, 0];
  for (var i = 0; i < dataList.length; i++) {
    a.add(dataList[i].type == 'Income'
        ? int.parse(dataList[i].amount)
        : int.parse(dataList[i].amount) * -1);
  }
  totals = a.reduce((value, element) => value + element);
  return totals;
}

int income() {
  var dataList = box.values.toList();
  List a = [0, 0];
  for (var i = 0; i < dataList.length; i++) {
    a.add(dataList[i].type == 'Income' ? int.parse(dataList[i].amount) : 0);
  }
  totals = a.reduce((value, element) => value + element);
  return totals;
}

int expense() {
  var dataList = box.values.toList();
  List a = [0, 0];
  for (var i = 0; i < dataList.length; i++) {
    a.add(
        dataList[i].type == 'Income' ? 0 : int.parse(dataList[i].amount) * -1);
  }
  totals = a.reduce((value, element) => value + element);
  return totals;
}

List<AddData> today() {
  List<AddData> a = [];
  var date = DateTime.now();
  var dataList = box.values.toList();
  for (var i = 0; i < dataList.length; i++) {
    if (dataList[i].datetime.day == date.day) {
      a.add(dataList[i]);
    }
  }
  return a;
}

List<AddData> weekly() {
  List<AddData> a = [];
  var date = DateTime.now();
  var dataList = box.values.toList();
  for (var i = 0; i < dataList.length; i++) {
    if (date.day - 7 <= dataList[i].datetime.day &&
        dataList[i].datetime.day <= date.day) {
      a.add(dataList[i]);
    }
  }
  return a;
}

List<AddData> monthly() {
  List<AddData> a = [];
  var date = DateTime.now();
  var dataList = box.values.toList();
  for (var i = 0; i < dataList.length; i++) {
    if (dataList[i].datetime.month == date.month) {
      a.add(dataList[i]);
    }
  }
  return a;
}

List<AddData> yearly() {
  List<AddData> a = [];
  var date = DateTime.now();
  var dataList = box.values.toList();
  for (var i = 0; i < dataList.length; i++) {
    if (dataList[i].datetime.year == date.year) {
      a.add(dataList[i]);
    }
  }
  return a;
}

int totalCharts(List<AddData> dataList) {
  List a = [0, 0];
  for (var i = 0; i < dataList.length; i++) {
    a.add(dataList[i].type == 'Income'
        ? int.parse(dataList[i].amount)
        : int.parse(dataList[i].amount) * -1);
  }
  totals = a.reduce((value, element) => value + element);
  return totals;
}

List time(List<AddData> dataList, bool hour) {
  List<AddData> a = [];
  List total = [];
  int counter = 0;
  for (var c = 0; c < dataList.length; c++) {
    for (var i = c; i < dataList.length; i++) {
      if (hour) {
        if (dataList[i].datetime.hour == dataList[c].datetime.hour) {
          a.add(dataList[i]);
          counter = i;
        }
      } else {
        if (dataList[i].datetime.day == dataList[c].datetime.day) {
          a.add(dataList[i]);
          counter = i;
        }
      }
    }
    total.add(totalCharts(a));
    a.clear();
    c = counter;
  }
  return total;
}
