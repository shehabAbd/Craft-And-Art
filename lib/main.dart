// ignore_for_file: prefer_const_constructors, unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logandsign/logic/bindings/auth_binding.dart';
import 'package:logandsign/providers/user_provider.dart';
import 'package:logandsign/routes/routes.dart';
import 'package:logandsign/utils/my_string.dart';
import 'package:logandsign/view/screens/home_screen.dart';
import 'package:logandsign/view/screens/main_screen.dart';
import 'package:logandsign/view/screens/splash/onboarding_screen.dart';
import 'package:logandsign/view/widgets/Buttom_Navigation_Bar.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.subscribeToTopic("all");

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: GetMaterialApp(
        initialBinding: AuthBinding(),
        debugShowCheckedModeBanner: false,
        locale: Locale(GetStorage().read<String>('lang').toString()),
        fallbackLocale: Locale(ene),
        title: "Craft and Art",
        //home: MainScreen(),
        builder: EasyLoading.init(),
        initialRoute: FirebaseAuth.instance.currentUser != null ||
                GetStorage().read<bool>("auth") == true
            ? AppRoutes.fingerPrint
            : AppRoutes.splash,
        getPages: AppRoutes.routes,
      ),
    );
  }
}
