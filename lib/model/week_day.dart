class WeekDay {
  String weekDay;
  String soup;
  String fish;
  String meat;
  String vegetarian;
  String desert;
  String? img;

  WeekDay({
    required this.weekDay,
    required this.soup,
    required this.fish,
    required this.meat,
    required this.vegetarian,
    required this.desert,
    this.img,
  });

  factory WeekDay.fromJson(Map<String, dynamic> json) {
    return WeekDay(
        weekDay: json["weekDay"],
        soup: json["soup"],
        fish: json["fish"],
        meat: json["meat"],
        vegetarian: json["vegetarian"],
        desert: json["desert"],
        img: json["img"]);
  }
}
