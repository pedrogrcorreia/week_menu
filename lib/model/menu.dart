class Menu {
  String weekDay;
  String soup;
  String fish;
  String meat;
  String vegetarian;
  String desert;
  String? img;

  Menu({
    required this.weekDay,
    required this.soup,
    required this.fish,
    required this.meat,
    required this.vegetarian,
    required this.desert,
    this.img,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
        weekDay: json["weekDay"],
        soup: json["soup"],
        fish: json["fish"],
        meat: json["meat"],
        vegetarian: json["vegetarian"],
        desert: json["desert"],
        img: json["img"]);
  }

  Map<String, dynamic> toJson() => {
        "weekDay": weekDay,
        "soup": soup,
        "fish": fish,
        "meat": meat,
        "vegetarian": vegetarian,
        "desert": desert,
        "img": img,
      };
}