import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.weekDay.weekDay)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            dayEdit(widget.weekDay, widget.weekDay.original,
                widget.weekDay.update, context, setState),
            ElevatedButton(
              onPressed: () async {
                final cameras = await availableCameras();
                if (mounted) {
                  image = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CameraPage(cameras: cameras)));
                }
                setState(() {});
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
