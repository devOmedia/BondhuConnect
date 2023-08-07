import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kotha/model/constance/color_constant.dart';
import 'package:kotha/model/constance/constant.dart';
import 'package:kotha/view/screens/settings/cookies_scren.dart';
import 'package:kotha/view/screens/settings/privacy_policy.dart';
import 'package:kotha/view/screens/settings/terms_conditions_screen.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});
  static const id = "/settingScreen";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SetteingScreenState();
}

class _SetteingScreenState extends ConsumerState<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        //s backgroundColor: KColors.primaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          AppConstants.screenBackgroundColor(),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, TermsAndCondition.id);
                },
                child: customItemCardWidget(
                    size: size, title: "Terms & Conditions"),
              ),
              AppConstants.getSpace(size.height * 0.02),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, PrivacyScreen.id);
                },
                child:
                    customItemCardWidget(size: size, title: "Privacy Policy"),
              ),
              AppConstants.getSpace(size.height * 0.02),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, CookiesScreen.id);
                },
                child:
                    customItemCardWidget(size: size, title: "Cookies Policy"),
              ),
              AppConstants.getSpace(size.height * .02),
              GestureDetector(
                onTap: () {
                  // deleteDialog(context);
                },
                child:
                    customItemCardWidget(size: size, title: "Delete account"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Center customItemCardWidget({size, title}) {
    return Center(
      child: Container(
          height: size.height * 0.08,
          width: size.width - 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            border: Border.all(
              color: KColors.secondaryColor,
            ),
          ),
          child: ListTile(
            title: Text(title),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
              size: size.width * 0.04,
            ),
          )),
    );
  }
}
