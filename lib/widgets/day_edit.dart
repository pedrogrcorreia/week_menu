import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:week_menu/model/menu.dart';
import 'package:week_menu/model/week_day.dart';
import 'package:http/http.dart' as http;
import 'package:week_menu/pages/camera_page.dart';

Future<http.Response> updateWeekDay(WeekDay weekDay) {
  var response = http.post(Uri.parse('http://10.0.2.2:8080/menu'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(weekDay.update?.toJson()));
  return response;
}

Widget dayEdit(
    WeekDay weekDay, Menu menu, Menu? menuUpdate, BuildContext context) {
  TextEditingController soupEdit =
      TextEditingController(text: menuUpdate?.soup ?? menu.soup);
  TextEditingController meatEdit =
      TextEditingController(text: menuUpdate?.meat ?? menu.meat);
  TextEditingController fishEdit =
      TextEditingController(text: menuUpdate?.fish ?? menu.fish);
  TextEditingController vegetarianEdit =
      TextEditingController(text: menuUpdate?.vegetarian ?? menu.vegetarian);
  TextEditingController desertEdit =
      TextEditingController(text: menuUpdate?.desert ?? menu.desert);
  return SingleChildScrollView(
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(weekDay.weekDay),
          Text(menu.soup),
          TextField(
            controller: soupEdit,
          ),
          Text(menu.meat),
          TextField(
            controller: meatEdit,
          ),
          Text(menu.fish),
          TextField(
            controller: fishEdit,
          ),
          Text(menu.vegetarian),
          TextField(
            controller: vegetarianEdit,
          ),
          Text(menu.desert),
          TextField(controller: desertEdit),
          ElevatedButton(
            onPressed: () {
              soupEdit.text = menu.soup;
              meatEdit.text = menu.meat;
              fishEdit.text = menu.fish;
              vegetarianEdit.text = menu.vegetarian;
              desertEdit.text = menu.desert;
            },
            child: Text("replace original"),
          ),
          ElevatedButton(
            onPressed: () async {
              var newMenu = Menu(
                  weekDay: menu.weekDay,
                  soup: soupEdit.text,
                  meat: meatEdit.text,
                  fish: fishEdit.text,
                  vegetarian: vegetarianEdit.text,
                  desert: desertEdit.text);
              var newWeekDay = WeekDay(
                  weekDay: menu.weekDay, original: menu, update: newMenu);
              await updateWeekDay(newWeekDay);
              Navigator.pop(context);
            },
            child: Text("Update"),
          ),
          ElevatedButton(
            onPressed: () async {
              await availableCameras().then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CameraPage(cameras: value))));
            },
            child: const Text("Take a Picture"),
          ),
        ],
      ),
    ),
  );
}
