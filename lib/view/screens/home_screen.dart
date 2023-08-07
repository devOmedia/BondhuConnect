// ignore_for_file: use_build_context_synchronously

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kotha/controller/connection_controllers/connection_controller.dart';
import 'package:kotha/controller/connection_controllers/connection_future_controller.dart';
import 'package:kotha/controller/data_providers/app_height_provider.dart';
import 'package:kotha/model/constance/color_constant.dart';
import 'package:kotha/model/constance/constant.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../model/local_db/user_data.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  static const id = "/home";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late double appbarHeight;
  late double bottomNavBarHeight;
  final List fevList =
      []; // store the id to represent the like button is selected or not,
  //because there is no data if the user is already selected or not.

  _loginToTheZigoCloud() async {
    // final id = ref.watch(userProvider).id;
    // final name = ref.watch(userProvider).name;

    final String id = await UserData.getUserID();
    final String name = await UserData.getUserName();
    // ZIMUserInfo userInfo = ZIMUserInfo();
    // userInfo.userID = id; //Fill in a String type value.
    // userInfo.userName = name; //Fill in a String type value.

    // ZIM.getInstance()!.login(userInfo).then((value) {
    //   //This will be triggered when login successful.
    //   log("login success..");
    // }).catchError((onError) {
    //   switch (onError.runtimeType) {
    //     //This will be triggered when login failed.
    //     case PlatformException:
    //       log(onError.code); //Return the error code when login failed.
    //       log(onError.message!); // Return the error indo when login failed.
    //       break;
    //     default:
    //   }
    // });

    //  await ZIMKit().connectUser(id: id, name: name);

    /// 4/5. initialized ZegoUIKitPrebuiltCallInvitationService when account is logged in or re-logged in
    ZegoUIKitPrebuiltCallInvitationService().init(
        appID: Keys.AppID /*input your AppID*/,
        appSign: Keys.appSign /*input your AppSign*/,
        userID: id,
        userName: name,
        notifyWhenAppRunningInBackgroundOrQuit: true,
        isIOSSandboxEnvironment: false,
        androidNotificationConfig: ZegoAndroidNotificationConfig(
          channelID: "ZegoUIKit",
          channelName: "Call Notifications",
          sound: "zego_incoming",
        ),
        plugins: [ZegoUIKitSignalingPlugin()],
        requireConfig: (ZegoCallInvitationData data) {
          final config = (data.invitees.length > 1)
              ? ZegoCallType.videoCall == data.type
                  ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                  : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
              : ZegoCallType.videoCall == data.type
                  ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                  : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

          /// support minimizing, show minimizing button
          config.topMenuBarConfig.isVisible = true;
          config.topMenuBarConfig.buttons
              .insert(0, ZegoMenuBarButtonName.minimizingButton);

          return config;
        });
  }

  @override
  void initState() {
    // _loginToTheZigoCloud();
    //_riveAnimationController = OneShotAnimation(animationName)
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    appbarHeight = ref.watch(appBarHeight);
    bottomNavBarHeight = ref.watch(bottomNavBarHeightProvider).getHeight();
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset("assets/logo/kotha_logo_1.svg"),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          AppConstants.screenBackgroundColor(),
          SizedBox(
            height: size.height * 0.6,
            child: ref.watch(homeProvider).when(
              data: (data) {
                if (data != null) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.data!.length,
                      itemBuilder: (context, index) {
                        return userCardItem(
                          size: size,
                          name: data.data![index].name,
                          profileID: data.data![index].id,
                          image: data.data![index].medium != null
                              ? data.data![index].medium!.url
                              : "https://t4.ftcdn.net/jpg/04/75/01/23/360_F_475012363_aNqXx8CrsoTfJP5KCf1rERd6G50K0hXw.jpg",
                        );
                      });

                  // userCardItem(size);
                } else {
                  //server error or token expire
                  //bcz no 401
                  ScaffoldMessenger.of(context)
                      .showSnackBar(AppConstants.getSnackBar(() {
                    ref.refresh(homeProvider);
                  }));
                }
                return const SizedBox();
              },
              error: (e, __) {
                // return null;
                return Text(e.toString());
              },
              loading: () {
                return const Center(
                  child:
                      CircularProgressIndicator(color: KColors.secondaryColor),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget userCardItem({size, name, profileID, image}) {
    return Container(
      margin: EdgeInsets.only(left: size.width * 0.1, bottom: 12),
      height: size.height * 0.5, // - (appbarHeight + bottomNavBarHeight + 33),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          // shadow container.
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [
                  KColors.primaryColor,
                  KColors.grey,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.mirror,
              ),
              color: const Color(0xFF78797A).withOpacity(0.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${name ?? ""}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: size.width * 0.05,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.greenAccent,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Online',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //==================================>>> fev button.
                    SizedBox(
                      height: size.height * 0.06,
                      width: size.width * 0.15,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            // rive.RiveAnimation.network(
                            //   "https://public.rive.app/community/runtime-files/375-1405-light-like.riv",
                            // )

                            IconButton(
                          onPressed: () async {
                            if (fevList.contains(profileID)) {
                              final response =
                                  await ref // delete the data from server
                                      .watch(connectionProvider)
                                      .deleteFromFev(profileID);

                              if (response != null) {
                                if (response["success"] == true) {
                                  setState(() {
                                    fevList.remove(profileID);
                                  }); // remove profile list from fev list.
                                  MotionToast.success(
                                          //show the success message
                                          description:
                                              Text(response["message"]))
                                      .show(context);
                                } else {
                                  // show the ser error
                                  MotionToast.error(
                                          description:
                                              Text(response["message"]))
                                      .show(context);
                                }
                              } else {
                                //server error
                                MotionToast.warning(
                                        description: const Text(
                                            "Something went wrong, please try again late."))
                                    .show(context);
                              }
                            } else {
                              final response = await ref
                                  .watch(connectionProvider)
                                  .addToFev(profileID);
                              if (response != null) {
                                if (response["success"] == true) {
                                  setState(() {
                                    fevList.add(profileID);
                                  }); // add profile list to fev list
                                  // show the success message
                                  MotionToast.success(
                                          description:
                                              Text(response["message"]))
                                      .show(context);
                                } else {
                                  // show the error message
                                  MotionToast.error(
                                          description:
                                              Text(response["message"]))
                                      .show(context);
                                }
                              } else {
                                //server error
                                MotionToast.warning(
                                        description: const Text(
                                            "Something went wrong, Please try again later."))
                                    .show(context);
                              }
                            }
                          },
                          icon: Icon(
                            Icons.favorite,
                            color: fevList.contains(profileID)
                                ? Colors.red
                                : Colors.white,
                            size: size.width * 0.06,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          FeatherIcons.messageCircle,
                          color: KColors.secondaryColor,
                          size: size.width * 0.06,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Stack clientCardWidget(Size size) {
    return Stack(
      children: [
        SizedBox(
          height: size.height * 0.7,
          width: size.width * 0.7,
          child: Image.asset(
            "assets/images/client.png",
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          right: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(
                Icons.favorite,
                color: KColors.grey,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey.withOpacity(0.1),
            child: Column(
              children: [
                Text(
                  "Sahara Khan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.badge,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Designer",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.034,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
