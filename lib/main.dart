import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kotha/firebase_options.dart';
import 'package:kotha/model/constance/color_constant.dart';
import 'package:kotha/model/constance/constant.dart';
import 'package:kotha/model/local_db/user_data.dart';
import 'package:kotha/view/screens/authentications/forget_password/forget_pssword_phone_number_screen.dart';
import 'package:kotha/view/screens/authentications/login_screen.dart';
import 'package:kotha/view/screens/authentications/show_user_interest_screen.dart';
import 'package:kotha/view/screens/authentications/signup_screen.dart';
import 'package:kotha/view/screens/authentications/user_photos_screen.dart';
import 'package:kotha/view/screens/balance/balance_screen.dart';
import 'package:kotha/view/screens/dashboard_screen.dart';
import 'package:kotha/view/screens/home_screen.dart';
import 'package:kotha/view/screens/messenger/messenger_screen.dart';
import 'package:kotha/view/screens/profile/about_me_screen.dart';
import 'package:kotha/view/screens/profile/user_profile_screen.dart';
import 'package:kotha/view/screens/settings/cookies_scren.dart';
import 'package:kotha/view/screens/settings/privacy_policy.dart';
import 'package:kotha/view/screens/settings/settings_screen.dart';
import 'package:kotha/view/screens/settings/terms_conditions_screen.dart';
import 'package:kotha/view/screens/splash/onboard_screen.dart';
import 'package:kotha/view/screens/splash/splash_screen.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import 'view/screens/authentications/user_interest_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Create a ZIM SDK instance.
//Create a ZIM SDK instance and pass in the AppID and AppSign.
  // ZIMAppConfig appConfig = ZIMAppConfig();
  // appConfig.appID = Keys.AppID;
  // appConfig.appSign = Keys.appSign;

  // ZIM.create(appConfig);
  // ZIMKit().init(
  //   appID: Keys.AppID, //  appid
  //   appSign: Keys.appSign, //  appSign
  // );
  //initialize firebase
  /// 1.1 define a navigator key
 

  /// 1.2: set navigator key to ZegoUIKitPrebuiltCallInvitationService
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(
      child: MyApp(
    navigatorKey: navigatorKey,
  )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.navigatorKey});
  final GlobalKey<NavigatorState> navigatorKey;

  _isUserLogged() async {
    final token = await UserData.getAccessToken();
    if (token != null) {
      return HomeScreen.id; // if we have the token then its logged
    } else {
      return OnboardScreen.id;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: KColors.primaryColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0XFFFFEDE8),
            elevation: 0,
          ),
          fontFamily: "DM Sans",
        ),
        initialRoute: HomeScreen.id,
        routes: {
          SplashScreen.id: (context) => const SplashScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          HomeScreen.id: (context) => const HomeScreen(),
          SignupScreen.id: (context) => const SignupScreen(),
          UserInterestScreen.id: (context) => const UserInterestScreen(),
          UserPhotosScreen.id: (context) => const UserPhotosScreen(),
          DeshBoardScreen.id: (context) => const DeshBoardScreen(),
          MessengerScreen.id: (context) => const MessengerScreen(),
          UserProfileScreen.id: (context) => const UserProfileScreen(),
          SettingScreen.id: (context) => const SettingScreen(),
          OnboardScreen.id: (context) => const OnboardScreen(),
          ForgetPasswordPhoneNumberScreen.id: (context) =>
              const ForgetPasswordPhoneNumberScreen(),
          // ResetPasswordScreen.id: (context) => const ResetPasswordScreen(),
          BalanceScreen.id: (context) => const BalanceScreen(),
          AboutMeScreen.id: (context) => const AboutMeScreen(),
          CookiesScreen.id: (context) => const CookiesScreen(),
          PrivacyScreen.id: (context) => const PrivacyScreen(),
          TermsAndCondition.id: (context) => const TermsAndCondition(),
          ShowUserInterestScreen.id: (context) =>
              const ShowUserInterestScreen(),
        },
      ),
    );
  }
}
