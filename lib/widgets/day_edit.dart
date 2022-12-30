import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:week_menu/model/week_day.dart';
import 'package:http/http.dart' as http;

void updateWeekDay(WeekDay weekDay) {
  http.post(Uri.parse('http://10.0.2.2:8080/menu'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(weekDay.toJson()));
}

Widget dayEdit(WeekDay weekDay, BuildContext context) {
  TextEditingController soupEdit = TextEditingController(text: weekDay.soup);
  TextEditingController meatEdit = TextEditingController(text: weekDay.meat);
  TextEditingController fishEdit = TextEditingController(text: weekDay.fish);
  TextEditingController vegetarianEdit =
      TextEditingController(text: weekDay.vegetarian);
  TextEditingController desertEdit =
      TextEditingController(text: weekDay.desert);
  return SingleChildScrollView(
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(weekDay.weekDay),
          TextField(
            controller: soupEdit,
          ),
          TextField(
            controller: meatEdit,
          ),
          TextField(
            controller: fishEdit,
          ),
          TextField(
            controller: vegetarianEdit,
          ),
          TextField(controller: desertEdit),
          ElevatedButton(
            onPressed: () {
              var newWeekDay = WeekDay(
                  weekDay: weekDay.weekDay,
                  soup: soupEdit.text,
                  meat: meatEdit.text,
                  fish: fishEdit.text,
                  vegetarian: vegetarianEdit.text,
                  desert: desertEdit.text);
              updateWeekDay(newWeekDay);
            },
            child: Text("Update"),
          ),
        ],
      ),
    ),
  );
}
