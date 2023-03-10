import 'dart:collection';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week_menu/model/week_day.dart';
import 'package:week_menu/pages/edit_menu.dart';
import 'package:week_menu/pages/preview_page.dart';
import 'package:week_menu/utils/strings.dart';
import 'dart:convert';

import 'package:week_menu/widgets/day.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;

  Future<List<WeekDay>>? _weekDays;

  String apiUrl = 'http://10.0.2.2:8080';

  Future<List<WeekDay>> _getWeekDays() async {
    if (_weekDays == null) {
      _weekDays = _fetchWeekDaysShared();
    } else {
      _weekDays = _fetchWeekDays();
    }
    return _weekDays!;
  }

  Future<List<WeekDay>> _fetchWeekDaysShared() async {
    print("getting this list from shared preferences!");
    List<WeekDay> weekDays = [];
    prefs = await SharedPreferences.getInstance();
    var weekDaysJson = prefs.getString("weekDays");
    var data = json.decode(utf8.decode(weekDaysJson!.codeUnits));

    var rest = data as LinkedHashMap<String, dynamic>;

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

    var removedDays = weekDays.getRange(0, todayIndex);

    weekDays.addAll(removedDays);

    weekDays.removeRange(0, todayIndex);

    return weekDays;
  }

  Future<List<WeekDay>> _fetchWeekDays() async {
    List<WeekDay> weekDays = [];
    var response = await http.get(
      Uri.parse("$apiUrl/menu"),
    );

    var data = json.decode(utf8.decode(response.bodyBytes));

    var rest = data as LinkedHashMap<String, dynamic>;

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

    var removedDays = weekDays.getRange(0, todayIndex);

    weekDays.addAll(removedDays);

    weekDays.removeRange(0, todayIndex);
    List<String> weekDaysJson = [];

    weekDays.forEach((element) {
      weekDaysJson.add(element.toJson().toString());
    });

    prefs.setString('weekDays', response.body);

    return weekDays;
  }

  @override
  void initState() {
    super.initState();
    sharedWeekDays();
    _weekDays = _fetchWeekDaysShared();
    checkPermissons();
  }

  void sharedWeekDays() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

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
                    future: _weekDays,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<WeekDay>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          var textColor = snapshot.data![index].update == null
                              ? Colors.black
                              : Colors.green;
                          return GestureDetector(
                              child: Card(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          (MediaQuery.of(context).size.width /
                                              3),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              Strings.getWeekDay(snapshot
                                                  .data![index].weekDay),
                                              style: TextStyle(
                                                  color: textColor,
                                                  fontSize: 25),
                                            ),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              child: snapshot.data![index]
                                                          .update?.img ==
                                                      null
                                                  ? const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: SizedBox(
                                                        width: 100,
                                                        height: 150,
                                                      ),
                                                    )
                                                  : Hero(
                                                      tag: "photo",
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Image.network(
                                                          "$apiUrl/images/${snapshot.data![index].update!.img!}",
                                                          fit: BoxFit.fitWidth,
                                                          width: 100,
                                                          height: 150,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Text(
                                                                "Erro a carregar imagem!");
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                              onTap: () async {
                                                if (snapshot.data![index].update
                                                        ?.img !=
                                                    null) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PreviewPage(
                                                                picture:
                                                                    "$apiUrl/images/${snapshot.data![index].update!.img!}",
                                                                title: snapshot
                                                                    .data![
                                                                        index]
                                                                    .weekDay,
                                                              )));
                                                }
                                              },
                                            ),
                                          )
                                        ],
                                      ),
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
                                            snapshot.data![index].original
                                                .vegetarian,
                                        textColor),
                                    _menuRow(
                                        "Sobremesa",
                                        snapshot.data![index].update?.desert ??
                                            snapshot
                                                .data![index].original.desert,
                                        textColor),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditMenu(
                                            weekDay: snapshot.data![index],
                                            apiUrl: apiUrl)));
                                setState(() {
                                  _weekDays = _fetchWeekDays();
                                });
                              });
                        } else if (snapshot.hasError) {
                          if (snapshot.error.toString() ==
                              "Connection refused") {
                            return Center(
                              child: Text('Imposs??vel ligar ao servidor!'),
                            );
                          } else {
                            return Center(
                              child: Text(
                                  "N??o tem dados armazenados para mostrar!"),
                            );
                          }
                        }
                      }
                      return const CircularProgressIndicator();
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
          setState(() {
            _weekDays = _fetchWeekDays();
          });
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
            title: Text(
              item,
              style: TextStyle(color: color),
            ),
            subtitle: Text(title),
          )
        ],
      ),
    );
  }

  void checkPermissons() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }
}
