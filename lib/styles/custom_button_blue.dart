// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/utils/text_utils.dart';

class Blue_Button extends StatelessWidget {
  final String text;

  final Function() onTap;

  const Blue_Button({Key? key, required this.onTap, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.06,
        margin: const EdgeInsets.only(left: 20, right: 20),
        decoration: const BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: TextUtils(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              text: text,
              color: AppColors.white,
              underLine: TextDecoration.none),
        ),
      ),
    );
  }
}
