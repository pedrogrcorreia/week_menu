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

  @override
  bool operator ==(Object other) {
    return other is Menu &&
        this.weekDay == other.weekDay &&
        this.soup == other.soup &&
        this.fish == other.fish &&
        this.meat == other.meat &&
        this.vegetarian == other.vegetarian &&
        this.desert == other.desert &&
        this.img == other.img;
  }

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
