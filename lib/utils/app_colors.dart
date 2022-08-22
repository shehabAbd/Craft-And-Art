import 'package:flutter/material.dart';

class AppColors {
  static const orange = Color(0xFFFFA726);
  static const darkGreyClr = Color.fromARGB(255, 109, 99, 99);
  static const blue = Color.fromARGB(255, 0, 97, 90);
  static const lightgreen = Color(0xFF4CAF50);
  static const white = Color(0xFFFFFFFF);
  static const grayshade = Color(0xFFEBEBEB);
  static const lightblue = Color(0xFF4B68D1);
  static const blackshade = Color(0xFF555555);
  static const hintText = Color(0xFFC7C7CD);

  AppColors(Function() color);
}

List<BoxShadow> shadowList = [
  BoxShadow(
      color: Colors.grey[300]!, blurRadius: 30, offset: const Offset(0, 10))
];
