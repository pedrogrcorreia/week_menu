import 'package:flutter/material.dart';
import 'package:week_menu/model/week_day.dart';

Widget day(WeekDay weekDay, BuildContext context) {
  return SingleChildScrollView(
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(weekDay.weekDay),
          Text(weekDay.soup),
          Text(weekDay.meat),
          Text(weekDay.fish),
          Text(weekDay.vegetarian),
          Text(weekDay.desert),
        ],
      ),
    ),
  );
}
