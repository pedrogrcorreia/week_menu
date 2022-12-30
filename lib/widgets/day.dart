import 'package:flutter/material.dart';
import 'package:week_menu/model/menu.dart';
import 'package:week_menu/model/week_day.dart';

Widget day(WeekDay weekDay, Menu menu, BuildContext context) {
  return SingleChildScrollView(
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(weekDay.weekDay),
          Text(menu.soup),
          Text(menu.meat),
          Text(menu.fish),
          Text(menu.vegetarian),
          Text(menu.desert),
        ],
      ),
    ),
  );
}
