import 'package:flutter/material.dart';
import 'package:week_menu/model/week_day.dart';

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
        ],
      ),
    ),
  );
}
