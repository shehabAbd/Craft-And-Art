import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget profileIcons(
  IconData icon,String name
) {
  return ElevatedButton.icon(
    icon: FaIcon(icon),
    onPressed: () {},
    style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 5),
      ),
    ),
    label: Text(
      name
    ),
  );
}
