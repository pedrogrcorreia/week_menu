import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:week_menu/model/week_day.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

void _fetchWeekDays() async {
  var response = await http.get(
    Uri.parse('http://10.0.2.2:8080/menu'),
  );
  var data = json.decode(response.body);

  var rest = data as LinkedHashMap<String, dynamic>;

  List<WeekDay> weekDays = [];

  rest.forEach((key, value) {
    weekDays.add(WeekDay.fromJson(value["original"]));
  });

  print(weekDays[0].desert);
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    _fetchWeekDays();
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: FutureBuilder<http.Response>(
                future: http.get(Uri.parse('http://10.0.2.2:8080/menu')),
                builder: (BuildContext context,
                    AsyncSnapshot<http.Response> snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!.body);
                  } else if (snapshot.hasError) {
                    return const Text('Oops, something happened');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
