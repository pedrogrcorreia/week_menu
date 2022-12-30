import 'package:week_menu/model/menu.dart';

class WeekDay {
  String weekDay;
  Menu original;
  Menu? update;

  WeekDay({
    required this.weekDay,
    required this.original,
    this.update,
  });

  factory WeekDay.fromJson(Map<String, dynamic> json) {
    return WeekDay(
      weekDay: json["original"]["weekDay"],
      original: Menu.fromJson(json["original"]),
      update: json["update"] == null ? null : Menu.fromJson(json["update"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "weekDay": weekDay,
        "original": original.toJson(),
        "update": update == null ? null : update?.toJson(),
      };
}
