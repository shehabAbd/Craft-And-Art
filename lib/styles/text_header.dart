import 'package:flutter/material.dart';
import 'package:logandsign/utils/app_colors.dart';
import 'package:logandsign/utils/text_utils.dart';

class CustomHeader extends StatelessWidget {
  final String text;
  
  const CustomHeader({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextUtils(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              text: text,
              color: AppColors.white,
              underLine: TextDecoration.none),
        ],
      ),
    );
  }
}
