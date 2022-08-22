import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logandsign/view/screens/chat/home_chat_screen.dart';
import 'package:logandsign/view/screens/favorites_screen.dart';
import 'package:logandsign/view/screens/home_screen.dart';
import 'package:logandsign/view/screens/search_screen_for_products.dart';
import 'package:logandsign/view/screens/settings_screen.dart';

class MainController extends GetxController {
  RxInt curentindex = 2.obs;

  final tabs = [
    const SettingsScreen(),
    HomeChatScreen(),
    const HomeScreen(),
    FavoritesScreen(uid: FirebaseAuth.instance.currentUser!.uid),
    const Search(),
  ].obs;
}
