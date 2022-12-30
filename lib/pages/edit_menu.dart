import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:week_menu/model/week_day.dart';
import 'package:week_menu/widgets/day_edit.dart';
import 'package:http/http.dart' as http;

class EditMenu extends StatefulWidget {
  const EditMenu({super.key, required this.weekDay});

  final WeekDay weekDay;
  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TODO ALTERAR")),
      body: Column(
        children: [
          dayEdit(widget.weekDay, widget.weekDay.original,
              widget.weekDay.update, context),
        ],
      ),
    );
  }
}
