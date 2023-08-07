// ignore_for_file: use_build_context_synchronously

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kotha/controller/connection_controllers/balance_controller.dart';
import 'package:kotha/model/constance/color_constant.dart';
import 'package:kotha/model/constance/constant.dart';
import 'package:kotha/model/local_db/user_data.dart';
import 'package:kotha/view/screens/authentications/login_screen.dart';
import 'package:kotha/view/screens/authentications/user_photos_screen.dart';
import 'package:kotha/view/screens/balance/balance_screen.dart';
import 'package:kotha/view/screens/profile/about_me_screen.dart';
import 'package:kotha/view/screens/settings/settings_screen.dart';
import 'package:kotha/view/widgets/user_details_bottomsheet.dart';

import '../../../controller/connection_controllers/connection_controller.dart';
import '../authentications/show_user_interest_screen.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});
  static const id = "/profileScreen";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  _getAge(String? dof) {
    if (dof != null) {
      final year = int.parse(dof.trim().split("-")[0]);

      return DateTime.now().year - year;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final profile = ref.watch(connectionProvider).userProfileModel;

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: KColors.primaryColor,
        leading: const SizedBox(),
        actions: [
          GestureDetector(
            onTap: () async {
              final response =
                  await ref.watch(balanceProvider).getUserBalance();
              if (response != null) {
                Navigator.pushNamed(context, BalanceScreen.id);
              } else {
                //gotoLogin(context);
              }
              Navigator.pushNamed(context, BalanceScreen.id);
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: KColors.secondaryColor),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset("assets/icons/Tk.svg"),
            ),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          AppConstants.screenBackgroundColor(),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //===================================================>>> top usr image.
                Center(
                  child: DottedBorder(
                    padding: const EdgeInsets.all(8),
                    color: KColors.secondaryColor,
                    borderType: BorderType.Circle,
                    child: Container(
                      height: size.height * 0.15,
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        //borderRadius: BorderRadius.circular(12),
                        child:
                            //data.data!.photoUrl != null
                            //? Image.network(data.data!.photoUrl!)
                            // :
                            profile != null
                                ? profile.data!.photoUrl != null
                                    ? Image.network(profile.data!.photoUrl!)
                                    : SvgPicture.asset(
                                        "assets/logo/kotha_logo_1.svg")
                                : SvgPicture.asset(
                                    "assets/logo/kotha_logo_1.svg"),
                      ),
                    ),
                  ),
                ),
                profile != null
                    ? profile.data!.name != null
                        ? Center(
                            child: Text(
                              profile.data!.name!,
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * 0.04),
                            ),
                          )
                        : const SizedBox()
                    : const SizedBox(),
                //====================================================>>>
                AppConstants.getSpace(size.height * 0.02),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, UserPhotosScreen.id);
                    },
                    child: Container(
                      height: size.height * 0.075,
                      width: size.width * 0.45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: KColors.secondaryColor,
                      ),
                      child: const Center(
                        child: Text(
                          "Add Photos or Videos",
                          style: TextStyle(
                            color: KColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                AppConstants.getSpace(size.height * 0.04),
                GestureDetector(
                  onTap: () {
                    ref.watch(connectionProvider).getUserProfileData();
                    if (ref.watch(connectionProvider).userProfileModel !=
                        null) {
                      getUserProfiledetailsBottomSheet(context, size,
                          ref.watch(connectionProvider).userProfileModel!);
                    }
                  },
                  child: Center(
                    child: Container(
                      width: size.width - 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        border: Border.all(color: KColors.secondaryColor),
                      ),
                      child: ListTile(
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: KColors.secondaryColor),
                        ),
                        title: const Text("Profile"),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: size.width * 0.04,
                        ),
                      ),
                    ),
                  ),
                ),
                AppConstants.getSpace(size.height * 0.02),
                //============================================>>> about me.
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AboutMeScreen.id);
                  },
                  child: Center(
                    child: Container(
                      width: size.width - 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        border: Border.all(color: KColors.secondaryColor),
                      ),
                      child: ListTile(
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: KColors.secondaryColor),
                        ),
                        title: const Text("About Me"),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: size.width * 0.04,
                        ),
                      ),
                    ),
                  ),
                ),
                AppConstants.getSpace(size.height * 0.02),
                //==============================================>>>
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ShowUserInterestScreen.id);
                  },
                  child: Center(
                    child: Container(
                      width: size.width - 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        border: Border.all(color: KColors.secondaryColor),
                      ),
                      child: ListTile(
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: KColors.secondaryColor),
                        ),
                        title: const Text("Interest"),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: size.width * 0.04,
                        ),
                      ),
                    ),
                  ),
                ),
                AppConstants.getSpace(size.height * 0.02),
                //==============================================>>>
                GestureDetector(
                  onTap: () {},
                  child: Center(
                    child: Container(
                      width: size.width - 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        border: Border.all(color: KColors.secondaryColor),
                      ),
                      child: ListTile(
                        onTap: () async {
                          final response =
                              await ref.watch(balanceProvider).getUserBalance();
                          if (response != null) {
                            Navigator.pushNamed(context, BalanceScreen.id);
                          } else {
                            //gotoLogin(context);
                          }
                          Navigator.pushNamed(context, BalanceScreen.id);
                        },
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: KColors.secondaryColor),
                        ),
                        title: Row(children: [
                          Image.asset("assets/images/balance.png"),
                          SizedBox(width: size.width * 0.02),
                          const Text("Balance"),
                        ]),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: size.width * 0.04,
                        ),
                      ),
                    ),
                  ),
                ),
                AppConstants.getSpace(size.height * 0.02),
                //==============================================>>>
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, SettingScreen.id);
                  },
                  child: Center(
                    child: Container(
                      width: size.width - 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        border: Border.all(color: KColors.secondaryColor),
                      ),
                      child: ListTile(
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: KColors.secondaryColor),
                        ),
                        title: Row(children: [
                          Image.asset("assets/images/settings.png"),
                          SizedBox(width: size.width * 0.02),
                          const Text("Settings"),
                        ]),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: size.width * 0.04,
                        ),
                      ),
                    ),
                  ),
                ),
                //==========================================================>>>>
                AppConstants.getSpace(size.height * 0.04),
                GestureDetector(
                  onTap: () async {
                    await UserData.deleteToken(); // delete the tokens
                    Navigator.pushReplacementNamed(context, LoginScreen.id);
                  },
                  child: Center(
                    child: Container(
                      height: size.height * 0.08,
                      width: size.width - 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: KColors.darkGrey,
                      ),
                      child: Center(
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: size.width * 0.04,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                AppConstants.getSpace(size.height * 0.04),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Center userCardWidget({size, title, subtitle}) {
    return Center(
      child: Container(
        //height: size.height * 0.08,
        width: size.width - 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: ListTile(
          title: Text(title),
          subtitle: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: KColors.green,
                ),
              ),
              const SizedBox(width: 8),
              const Text("Online")
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
            size: size.width * 0.04,
          ),
        ),
      ),
    );
  }
}
