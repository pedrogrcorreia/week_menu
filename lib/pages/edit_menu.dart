import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:week_menu/model/menu.dart';
import 'package:week_menu/model/week_day.dart';
import 'package:week_menu/pages/camera_page.dart';
import 'package:week_menu/widgets/day_edit.dart';
import 'package:http/http.dart' as http;

class EditMenu extends StatefulWidget {
  const EditMenu({super.key, required this.weekDay});

  final WeekDay weekDay;

  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  XFile? image;
  String? image64;

  late TextEditingController soupEdit;
  late TextEditingController meatEdit;
  late TextEditingController fishEdit;
  late TextEditingController vegetarianEdit;
  late TextEditingController desertEdit;
  late Menu menu;
  late Menu? menuUpdate;

  @override
  void initState() {
    menu = widget.weekDay.original;
    menuUpdate = widget.weekDay.update;
    soupEdit = TextEditingController(text: menuUpdate?.soup ?? menu.soup);
    meatEdit = TextEditingController(text: menuUpdate?.meat ?? menu.meat);
    fishEdit = TextEditingController(text: menuUpdate?.fish ?? menu.fish);
    vegetarianEdit =
        TextEditingController(text: menuUpdate?.vegetarian ?? menu.vegetarian);
    desertEdit = TextEditingController(text: menuUpdate?.desert ?? menu.desert);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.weekDay.weekDay)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(widget.weekDay.weekDay),
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
                    desert: desertEdit.text,
                    img: image64 ?? null);
                var newWeekDay = WeekDay(
                    weekDay: menu.weekDay, original: menu, update: newMenu);
                await updateWeekDay(newWeekDay);
                Navigator.pop(context);
              },
              child: Text("Update"),
            ),
            ElevatedButton(
              onPressed: () async {
                final cameras = await availableCameras();
                if (mounted) {
                  image = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CameraPage(cameras: cameras)));
                }
                setState(() {
                  File file = File(image!.path);
                  image64 = base64Encode(file.readAsBytesSync());
                  print(image64);
                });
              },
              child: const Text("Take a Picture"),
            ),
            if (image != null)
              Image.file(File(image!.path), fit: BoxFit.cover, width: 250),
          ],
        ),
      ),
    );
  }
}
