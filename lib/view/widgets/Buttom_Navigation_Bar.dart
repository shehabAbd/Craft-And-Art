import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:logandsign/utils/app_colors.dart';

class BottumNavBar extends StatefulWidget {
  const BottumNavBar({Key? key}) : super(key: key);

  @override
  State<BottumNavBar> createState() => _BottumNavBarState();
}

class _BottumNavBarState extends State<BottumNavBar> {
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          const Icon(
            Icons.person,
            size: 30,
          ),
          const Icon(
            Icons.chat,
            size: 30,
          ),
          InkWell(
            onTap: () {
              
            },
            child: const Icon(
              Icons.home,
              size: 30,
            ),
          ),
          const Icon(
            Icons.search,
            size: 30,
          ),
        ],
        color: AppColors.grayshade,
        buttonBackgroundColor: AppColors.blue,
        backgroundColor: AppColors.orange,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 500),
        onTap: (index) {},
        
        
        height: 50.5,
      ),
    );
  }
}
