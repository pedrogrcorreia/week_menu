import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:week_menu/utils/strings.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.picture, required this.title})
      : super(key: key);

  final String picture;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ementa de " + Strings.getWeekDay(title))),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Hero(
              tag: "photo",
              child: Image.network(picture, fit: BoxFit.cover, width: 250)),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }
}
