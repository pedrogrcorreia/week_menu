import 'dart:collection';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:week_menu/model/week_day.dart';
import 'package:week_menu/pages/edit_menu.dart';
import 'package:week_menu/pages/preview_page.dart';
import 'dart:convert';

import 'package:week_menu/widgets/day.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

Future<List<WeekDay>> _fetchWeekDays() async {
  var response = await http.get(
    Uri.parse('http://192.168.1.86:8080/menu'),
  );
  var data = json.decode(utf8.decode(response.bodyBytes));

  var rest = data as LinkedHashMap<String, dynamic>;

  List<WeekDay> weekDays = [];

  rest.forEach((key, value) {
    weekDays.add(WeekDay.fromJson(value));
  });

  var today = DateFormat('EEEE').format(DateTime.now());
  var todayIndex = 0;

  for (var i = 0; i < weekDays.length; i++) {
    if (weekDays[i].weekDay == today.toUpperCase()) {
      todayIndex = i;
    }
  }

  var removedDays = weekDays.getRange(0, 2);

  weekDays.addAll(removedDays);

  weekDays.removeRange(0, todayIndex);

  return weekDays;
}

class _HomePageState extends State<HomePage> {
  var backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) {
            return SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: FutureBuilder<List<WeekDay>>(
                    future: _fetchWeekDays(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<WeekDay>> snapshot) {
                      if (snapshot.hasData) {
                        var textColor = snapshot.data![index].update == null
                            ? Colors.black
                            : Colors.green;
                        return GestureDetector(
                            child: Card(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        snapshot.data![index].weekDay,
                                        style: TextStyle(color: textColor),
                                      ),
                                      GestureDetector(
                                        child: Image.asset(
                                            "assets/images/Sopa.jpg"),
                                        onTap:
                                            () {}, // TODO Abrir aqui a imagem
                                      )
                                    ],
                                  ),
                                  _menuRow(
                                      "Sopa",
                                      snapshot.data![index].update?.soup ??
                                          snapshot.data![index].original.soup,
                                      textColor),
                                  _menuRow(
                                      "Carne",
                                      snapshot.data![index].update?.meat ??
                                          snapshot.data![index].original.meat,
                                      textColor),
                                  _menuRow(
                                      "Peixe",
                                      snapshot.data![index].update?.fish ??
                                          snapshot.data![index].original.fish,
                                      textColor),
                                  _menuRow(
                                      "Vegetariano",
                                      snapshot.data![index].update
                                              ?.vegetarian ??
                                          snapshot
                                              .data![index].original.vegetarian,
                                      textColor),
                                  _menuRow(
                                      "Sobremesa",
                                      snapshot.data![index].update?.desert ??
                                          snapshot.data![index].original.desert,
                                      textColor),
                                ],
                              ),
                            ),
                            onTap: () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditMenu(
                                          weekDay: snapshot.data![index])));
                              setState(() {});
                            });
                      } else if (snapshot.hasError) {
                        print("Snapshot error ${snapshot.error}");
                        return const Text('Oops, something happened');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _menuRow(String title, String item, Color color) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Image.asset("assets/images/$title.jpg"),
            title: Text(item),
            subtitle: Text(title),
          )
        ],
      ),
    );
  }
}
