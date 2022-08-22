

import 'package:flutter/material.dart';
import 'package:logandsign/utils/app_colors.dart';


class Gender extends StatefulWidget {
  const Gender({Key? key}) : super(key: key);

  @override
  _GenderState createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  List<String> items = <String>["2", "1"];
  String? dropdownvalue = "2";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            hint: Text(
              "اختر العمر من هنا",
            ),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: AppColors.orange),
                borderRadius: BorderRadius.circular(20),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: AppColors.orange),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            
            items: items
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onChanged: (item) => setState(() => dropdownvalue = item),
          ),
        ),
      ),
    );
  }
}

class Nation extends StatefulWidget {
  const Nation({Key? key}) : super(key: key);

  @override
  _NationState createState() => _NationState();
}

class _NationState extends State<Nation> {
  List<String> items = <String>["ذكر", "انثى"];
  String? dropdownvalue = "ذكر";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DropdownButtonFormField<String>(
          hint: Text("اختر الجنس من هنا"),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: AppColors.orange),
              borderRadius: BorderRadius.circular(20),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: AppColors.orange),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: (item) => setState(() => dropdownvalue = item),
        ),
      ),
    );
  }
}
