import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:week_menu/model/week_day.dart';
import 'package:week_menu/pages/edit_menu.dart';
import 'dart:convert';

import 'package:week_menu/widgets/day.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

Future<List<WeekDay>> _fetchWeekDays() async {
  print("Getting data from server");
  var response = await http.get(
    Uri.parse('http://192.168.1.86:8080/menu'),
  );
  print(response.statusCode);
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

  weekDays.forEach((element) {
    print(element.update?.desert);
  });

  return weekDays;
}

class _HomePageState extends State<HomePage> {
  var backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder<List<WeekDay>>(
              future: _fetchWeekDays(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<WeekDay>> snapshot) {
                if (snapshot.hasData) {
                  return GestureDetector(
                      child: day(
                          snapshot.data![index],
                          snapshot.data![index].update ??
                              snapshot.data![index].original,
                          context),
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditMenu(weekDay: snapshot.data![index])));
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.navigation),
      ),
    );
  }
}
