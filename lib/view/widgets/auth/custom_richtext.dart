import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logandsign/utils/app_colors.dart';

class CustomRichText extends StatelessWidget {
  final String discription;
  final String text;
  final Function() onTap;
  final Color color;
  const CustomRichText(
      {Key? key,
      required this.discription,
      required this.text,
      required this.onTap,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
        child: Text.rich(
          TextSpan(
              text: discription,
              style: const TextStyle(color: AppColors.darkGreyClr, fontSize: 16),
              children: [
                TextSpan(
                    text: text,
                    style: TextStyle(color: color),
                    recognizer: TapGestureRecognizer()..onTap = onTap),
              ]),
        ),
      ),
    );
  }
}
