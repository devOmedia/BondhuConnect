import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kotha/model/constance/color_constant.dart';
import 'package:kotha/model/local_db/user_data.dart';
import 'package:kotha/model/onboard/onboard_model.dart';
import 'package:kotha/view/screens/authentications/login_screen.dart';
import 'package:kotha/view/screens/authentications/signup_screen.dart';
import 'package:uuid/uuid.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({Key? key}) : super(key: key);
  static const id = "/onBoard";

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  int currentIndex = 0;

  List<AllinOnboardModel> allinonboardlist = [
    AllinOnboardModel(
      "assets/onboard/onboard1.svg",
      "Talk to anyone",
    ),
    AllinOnboardModel(
      "assets/images/onboard_2.png",
      "The more you talk,\nthe more you earn 24/7",
    ),
  ];

  _storeTheDeviceID() async {
    final hasDeviceID = await UserData.getDeviceID();
    //if we don't have any device id.
    if (hasDeviceID == null) {
      final deviceID = const Uuid().v4();
      await UserData.setTheDeviceID(deviceID);
    }
  }

  @override
  void initState() {
    _storeTheDeviceID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                itemCount: allinonboardlist.length,
                itemBuilder: (context, index) {
                  return PageBuilderWidget(
                    description: allinonboardlist[index].description,
                    imgurl: allinonboardlist[index].imgStr,
                    index: index,
                  );
                }),
            //========================================>>> App Icon
            Positioned(
              top: 20,
              left: size.width * 0.4,
              child: SizedBox(
                width: size.width * 0.15,
                child: SvgPicture.asset("assets/logo/kotha_logo_1.svg"),
              ),
            ),
            //================================================>>> animated slider.
            // Positioned(
            //   bottom: size.width * 0.55,
            //   left: size.width * 0.45,
            //   // right: 20,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: List.generate(
            //           allinonboardlist.length,
            //           (index) => buildDot(index: index),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            //=========================================>>> buttons
            Positioned(
              bottom: size.width * 0.18,
              left: 20,
              right: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      allinonboardlist.length,
                      (index) => buildDot(index: index),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SignupScreen.id);
                    },
                    child: Container(
                      width: size.width * 0.8,
                      height: size.height * 0.07,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: KColors.secondaryColor,
                      ),
                      child: Center(
                        child: Text(
                          "Create an account",
                          style: TextStyle(
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.w700,
                            color: KColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                    child: Container(
                      width: size.width * 0.8,
                      height: size.height * 0.07,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: KColors.primaryColor,
                        border: Border.all(
                          color: KColors.secondaryColor,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "Log in",
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.w700,
                          color: KColors.secondaryColor,
                        ),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentIndex == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentIndex == index
            ? KColors.secondaryColor
            : const Color.fromARGB(255, 248, 201, 192),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class PageBuilderWidget extends StatelessWidget {
  String description;
  String imgurl;
  int index;
  PageBuilderWidget(
      {Key? key,
      required this.description,
      required this.imgurl,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: size.height * 0.15),
          SizedBox(
            width: size.width * 0.6,
            child: index == 0 ? SvgPicture.asset(imgurl) : Image.asset(imgurl),
          ),
          const SizedBox(
            height: 20,
          ),

          ///============================
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: KColors.black,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
