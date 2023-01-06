import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:week_menu/model/menu.dart';
import 'package:week_menu/model/week_day.dart';
import 'package:week_menu/pages/camera_page.dart';
import 'package:week_menu/widgets/day_edit.dart';
import 'package:http/http.dart' as http;

class EditMenu extends StatefulWidget {
  const EditMenu({super.key, required this.weekDay});

  final WeekDay weekDay;

  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  XFile? image;
  String? image64;

  late TextEditingController soupEdit;
  late TextEditingController meatEdit;
  late TextEditingController fishEdit;
  late TextEditingController vegetarianEdit;
  late TextEditingController desertEdit;
  late Menu menuOriginal;
  late Menu? menuUpdate;

  late Menu menu;

  Menu? pastMenu;

  @override
  void initState() {
    menuOriginal = widget.weekDay.original;
    menuUpdate = widget.weekDay.update;
    pastMenu = menuUpdate;
    menu = menuUpdate != null ? menuUpdate! : menuOriginal;
    soupEdit = TextEditingController(text: menuUpdate?.soup ?? menu.soup);
    meatEdit = TextEditingController(text: menuUpdate?.meat ?? menu.meat);
    fishEdit = TextEditingController(text: menuUpdate?.fish ?? menu.fish);
    vegetarianEdit =
        TextEditingController(text: menuUpdate?.vegetarian ?? menu.vegetarian);
    desertEdit = TextEditingController(text: menuUpdate?.desert ?? menu.desert);
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.weekDay.weekDay)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _menuRow("Sopa", menuOriginal.soup, menuUpdate?.soup, Colors.black,
                soupEdit),
            _menuRow("Carne", menuOriginal.meat, menuUpdate?.meat, Colors.black,
                meatEdit),
            _menuRow("Peixe", menuOriginal.fish, menuUpdate?.fish, Colors.black,
                fishEdit),
            _menuRow("Vegetariano", menuOriginal.vegetarian,
                menuUpdate?.vegetarian, Colors.black, vegetarianEdit),
            _menuRow("Sobremesa", menuOriginal.desert, menuUpdate?.desert,
                Colors.black, desertEdit),
            ElevatedButton(
              onPressed: () {
                soupEdit.text = menu.soup;
                meatEdit.text = menu.meat;
                fishEdit.text = menu.fish;
                vegetarianEdit.text = menu.vegetarian;
                desertEdit.text = menu.desert;
              },
              child: Text("replace original"),
            ),
            ElevatedButton(
              onPressed: () async {
                var newMenu = Menu(
                    weekDay: menu.weekDay,
                    soup: soupEdit.text,
                    meat: meatEdit.text,
                    fish: fishEdit.text,
                    vegetarian: vegetarianEdit.text,
                    desert: desertEdit.text,
                    img: image64);
                pastMenu?.img = null;
                if (newMenu == menuOriginal || pastMenu == menuUpdate) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Não fez alterações ao menu!"),
                    ),
                  );
                  return;
                }
                var newWeekDay = WeekDay(
                    weekDay: menu.weekDay, original: menu, update: newMenu);
                await updateWeekDay(newWeekDay);
                Navigator.pop(context);
              },
              child: const Text("Atualizar"),
            ),
            ElevatedButton(
              onPressed: () async {
                final cameras = await availableCameras();
                if (mounted) {
                  image = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CameraPage(cameras: cameras)));
                }
                setState(() {
                  File file = File(image!.path);
                  image64 = base64Encode(file.readAsBytesSync());
                  menuUpdate = getUpdatedMenu();
                });
              },
              child: const Text("Take a Picture"),
            ),
            if (image != null)
              Image.file(File(image!.path), fit: BoxFit.cover, width: 250),
          ],
        ),
      ),
    );
  }

  Widget _menuRow(
    String title,
    String itemOriginal,
    String? itemUpdate,
    Color color,
    TextEditingController controller,
  ) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            leading: Image.asset("assets/images/$title.jpg"),
            title: Column(children: [
              Card(
                child: ListTile(
                  title: Text(itemOriginal),
                  subtitle: Text("Original"),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              title: Text("Editar $title"),
                              content: Column(
                                children: [
                                  TextField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    controller: controller,
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            menuUpdate = getUpdatedMenu();
                                            setState(() {});
                                            Navigator.pop(context, true);
                                          },
                                          child: Text("Ok")),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: Text("Cancelar")),
                                    ],
                                  ),
                                ],
                              ));
                        },
                      );
                    },
                  ),
                ),
              ),
              Card(
                color: Colors.greenAccent,
                child: ListTile(
                  title: Text(itemUpdate ?? "Sem alterações"),
                  subtitle: Text("Update"),
                  trailing: IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {},
                  ),
                ),
              ),
            ]),
            subtitle: Text(title),
          )
        ],
      ),
    );
  }

  Menu getUpdatedMenu() {
    return Menu(
        weekDay: menu.weekDay,
        soup: soupEdit.text == menuOriginal.soup
            ? menuOriginal.soup
            : soupEdit.text,
        meat: meatEdit.text == menuOriginal.meat
            ? menuOriginal.meat
            : meatEdit.text,
        fish: fishEdit.text == menuOriginal.fish
            ? menuOriginal.fish
            : fishEdit.text,
        vegetarian: vegetarianEdit.text == menuOriginal.vegetarian
            ? menuOriginal.vegetarian
            : vegetarianEdit.text,
        desert: desertEdit.text == menuOriginal.desert
            ? menuOriginal.desert
            : desertEdit.text,
        img: image64);
  }
}
