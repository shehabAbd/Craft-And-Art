import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logandsign/utils/app_colors.dart';

class TextUtils extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextDecoration underLine;

  const TextUtils({
    required this.fontSize,
    required this.fontWeight,
    required this.text,
    required this.color,
    required this.underLine,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.lato(
        textStyle: TextStyle(
          decoration: underLine,
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
 bool isloading = false;
 void  returnText(){
    isloading ? const Center(child: CircularProgressIndicator(color: AppColors.orange,),) : "انشاء حساب";
 }
