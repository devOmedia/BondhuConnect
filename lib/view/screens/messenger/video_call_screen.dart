import 'package:flutter/material.dart';
import 'package:kotha/model/constance/constant.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen(
      {Key? key,
      required this.callID,
      required this.userID,
      required this.userName})
      : super(key: key);
  final String callID;
  final String userID;
  final String userName;
  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: Keys.AppID,
      appSign: Keys.appSign,
      userID: userID,
      userName: userName,
      callID: callID,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..onOnlySelfInRoom = (context) => Navigator.of(context).pop(),
    );
  }
}
