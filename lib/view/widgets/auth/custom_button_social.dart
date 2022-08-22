import 'package:flutter/material.dart';
import 'package:logandsign/utils/colors.dart';

import 'custom_text.dart';

class CustomButtonSocial extends StatelessWidget {
  final String text;
  final String imageName;
  final Function onPress;

  const CustomButtonSocial({
    required this.text,
    required this.imageName,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          color: Colors.grey.shade50,
        ),
        child: FlatButton(
          onPressed: onPress(),
          shape: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Row(
            children: [
              CustomText(

                maxLine: 1,
                text: text, textStyle: const TextStyle(color: appBarIconButtonColor, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                width: 100,
              ),
              Image.asset(imageName),
            ],
          ),
        ),
      ),
    );
  }
}
