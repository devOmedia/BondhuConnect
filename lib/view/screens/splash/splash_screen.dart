import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kotha/model/constance/color_constant.dart';
import 'package:kotha/model/local_db/user_data.dart';
import 'package:kotha/view/screens/dashboard_screen.dart';
import 'package:kotha/view/screens/splash/onboard_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  static const id = "/";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  // check if we have any token
  // if any then goto  the home screen
  // or login
  _gotoNextScreen() async {
    final token = await UserData.getAccessToken();

    Future.delayed(const Duration(milliseconds: 1000)).then((_) {
      if (token != null) {
        Navigator.pushReplacementNamed(context, DeshBoardScreen.id);
      } else {
        Navigator.pushReplacementNamed(context, OnboardScreen.id);
      }
    });
  }

  @override
  void initState() {
    _gotoNextScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: KColors.secondaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              height: size.height * 0.1,
              width: size.width * 0.25,
              decoration: BoxDecoration(
                  color: KColors.primaryColor,
                  borderRadius: BorderRadius.circular(12)),
              child: SvgPicture.asset("assets/logo/kotha_logo_1.svg"),
            ),
            const Text(
              "Porichoy",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 32,
              ),
            )
          ],
        ),
      ),
    );
  }
}
