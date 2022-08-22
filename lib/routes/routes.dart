import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logandsign/logic/bindings/authentication_binding.dart';
import 'package:logandsign/view/screens/auth/authentication_screen.dart';
import 'package:logandsign/logic/bindings/login_binding.dart';
import 'package:logandsign/view/screens/auth/login_creative_screen.dart';
import 'package:logandsign/logic/bindings/registration_binding.dart';
import 'package:logandsign/view/screens/auth/registration_screen.dart';
import 'package:logandsign/view/screens/auth/fingerprint_screen.dart';
import 'package:logandsign/view/screens/hello_screen.dart';
import 'package:logandsign/logic/bindings/auth_binding.dart';
import 'package:logandsign/logic/bindings/main_binding.dart';
import 'package:logandsign/view/screens/auth/forgot_password_screen.dart';
import 'package:logandsign/view/screens/auth/login_user_screen.dart';
import 'package:logandsign/view/screens/auth/signup_user_screen.dart';
import 'package:logandsign/view/screens/craft/add_craft_screen.dart';
import 'package:logandsign/view/screens/favorites_screen.dart';
import 'package:logandsign/view/screens/home_screen.dart';
import 'package:logandsign/view/screens/main_screen.dart';
import 'package:logandsign/view/screens/profile_creative_screen.dart';
import 'package:logandsign/view/screens/settings_screen.dart';
import 'package:logandsign/view/screens/splash/onboarding_screen.dart';
import 'package:logandsign/view/screens/welcome_screen.dart';

class AppRoutes {
  static const Splash = Routes.splashScreen;

  static const loginUser = Routes.loginUserScreen;

  static const signUpUser = Routes.signUpUserScreen;
  static const favorites = Routes.favoritesScreen;
  static const main = Routes.mainScreen;
  static const home = Routes.homeScreen;
  static const settings = Routes.settingsScreen;

  static const welcom = Routes.welcomeScreen;
  static const addCraft = Routes.addcraftScreen;

  static const profile = Routes.profileScreen;

  static const splash = Routes.splashScreen;
  static const forgetPassword = Routes.forgetPasswordScreen;
  static const helloScreen = Routes.helloScreen;
  static const fingerPrint = Routes.fingerPrint;
  static const registrationCreative = Routes.registrationCreative;
  static const authentication = Routes.authentication;
  static const loginCreative = Routes.loginCreativeScreen;

  static final routes = [
    GetPage(
      name: Routes.splashScreen,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: Routes.forgetPasswordScreen,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.loginUserScreen,
      page: () => const LoginUser(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.signUpUserScreen,
      page: () => const SignUpUser(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.homeScreen,
      page: () => const HomeScreen(),
      bindings: [AuthBinding(), MainBinding()],
    ),
    GetPage(
      name: Routes.mainScreen,
      page: () => const MainScreen(),
      bindings: [AuthBinding(), MainBinding()],
    ),
    GetPage(
      name: Routes.favoritesScreen,
      page: () => FavoritesScreen(
        uid: FirebaseAuth.instance.currentUser!.uid,
      ),
    ),
    GetPage(
      name: Routes.settingsScreen,
      page: () => const SettingsScreen(),
    ),
    GetPage(
      name: Routes.profileScreen,
      page: () => ProfileScreen(
        uid: FirebaseAuth.instance.currentUser!.uid,
      ),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.addcraftScreen,
      page: () => const AddCraftScreen(),
    ),
    GetPage(
      name: Routes.welcomeScreen,
      page: () => const WelcomeScreen(),
    ),
    GetPage(
      name: Routes.helloScreen,
      page: () => const HelloScreen(),
    ),
    GetPage(
      name: Routes.fingerPrint,
      page: () => const Fingerprint(),
    ),
    GetPage(
      name: Routes.registrationCreative,
      page: () => RegistrationScreen(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: Routes.authentication,
      page: () => const AuthenticationScreen(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: Routes.loginCreativeScreen,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
  ];
}

class Routes {
  static const loginCreativeScreen = "/loginCreativeScreen";

  static const authentication = "/authentication";
  static const registrationCreative = "/registrationCreative";

  static const fingerPrint = "/fingerPrint";

  static const helloScreen = "/helloScreen";
  static const splashScreen = "/splashScreen";
  static const forgetPasswordScreen = "/forgetPasswordScreenScreen";

  static const loginUserScreen = "/loginUserScreen";

  static const signUpUserScreen = "/signUpUserScreen";
  static const categoryScreen = "/categoryScreen";
  static const favoritesScreen = "/favoritesScreen";
  static const homeScreen = "/homeScreen";
  static const settingsScreen = "/settingsScreen";
  static const welcomeScreen = "/welcomeScreen";
  static const mainScreen = "/mainScreen";
  static const addcraftScreen = "/addcraftScreen";
  static const profileScreen = "/ProfileScreen";
}
