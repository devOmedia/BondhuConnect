import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'package:intl/intl.dart';
import 'package:kotha/model/constance/color_constant.dart';
import 'package:kotha/model/local_db/user_data.dart';
import 'package:kotha/view/screens/messenger/conversation_screen.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../../controller/convo_controller/chat_controller.dart';
import '../../../model/constance/constant.dart';

class MessengerScreen extends ConsumerStatefulWidget {
  const MessengerScreen({super.key});
  static const id = "/messengerScreen";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MessengerScreenState();
}

class _MessengerScreenState extends ConsumerState<MessengerScreen> {
  @override
  void initState() {
    onUserLogin();
    super.initState();
  }

  _formateConvoTime(String dateTime) {
    DateTime tempDate = DateTime.parse(dateTime); //convert the date time.

    if (tempDate.day == DateTime.now().day) {
      //check if the convo date is current day.
      return DateFormat.Hm().format(tempDate).toString();
    } else {
      return "Yesterday";
    }
  }

  /// on App's user login
  void onUserLogin() async {
    final userID = await UserData.getUserID();
    final userName = await UserData.getUserName();

    /// 2.1. initialized ZegoUIKitPrebuiltCallInvitationService
    /// when app's user is logged in or re-logged in
    /// We recommend calling this method as soon as the user logs in to your app.
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: Keys.AppID /*input your AppID*/,
      appSign: Keys.appSign /*input your AppSign*/,
      userID: userID,
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }

  void onSendCallInvitationFinished(
    String code,
    String message,
    List<String> errorInvitees,
  ) {
    if (errorInvitees.isNotEmpty) {
      String userIDs = "";
      for (int index = 0; index < errorInvitees.length; index++) {
        if (index >= 5) {
          userIDs += '... ';
          break;
        }

        var userID = errorInvitees.elementAt(index);
        userIDs += '$userID ';
      }
      if (userIDs.isNotEmpty) {
        userIDs = userIDs.substring(0, userIDs.length - 1);
      }

      var message = 'User doesn\'t exist or is offline: $userIDs';
      if (code.isNotEmpty) {
        message += ', code: $code, message:$message';
      }
      showToast(
        message,
        position: StyledToastPosition.top,
        context: context,
      );
    } else if (code.isNotEmpty) {
      showToast(
        'code: $code, message:$message',
        position: StyledToastPosition.top,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        elevation: sqrt1_2,
        backgroundColor: KColors.primaryColor,
        centerTitle: true,
        title: Text(
          "Messages",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        //actions: const [HomePagePopup()],
      ),
      body: ref.watch(chatProvider).when(
          data: (data) {
            if (data != null) {
              return ListView.builder(
                itemCount: data.data!.length,
                itemBuilder: (context, index) {
                  final room = data.data![index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConversationScreen(
                            id: room.id.toString(),
                            name: room.user!.name!,
                            photoUrl: room.user!.medium!.url!,
                          ),
                        ),
                      );
                    },
                    // dense: true,
                    title: Text(
                      room.user!.name ?? "",
                      style: const TextStyle(
                        color: KColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //=============================>> last message
                    subtitle: Text(
                      room.conversations!
                              .isNotEmpty // check if the room has any conversation
                          ? room.conversations![0].type ==
                                  "chat" // check if the content type is chat,
                              ? room.conversations![0].content!
                              : room.conversations![0].type ==
                                      "tips" // check if the content type is tips,
                                  ? "Received ৳ ${room.conversations![0].content!.split('.')[0]}"
                                  : ""
                          : "",
                      style: TextStyle(
                        color: room.conversations!
                                .isNotEmpty // check the room has conversation and is so then check is the last conversation is seen or not.
                            ? room.conversations![0].isSeen != true
                                ? KColors.black
                                : KColors.grey
                            : KColors.grey,
                        fontWeight: room.conversations!
                                .isNotEmpty // check the room has conversation and is so then check is the last conversation is seen or not.
                            ? room.conversations![0].isSeen != true
                                ? FontWeight.w600
                                : FontWeight.normal
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: Text(
                      room.conversations!
                              .isNotEmpty // check if the room has any conversation
                          ? _formateConvoTime(room.conversations![0].createdAt!)
                          : "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: KColors.black,
                      ),
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: size.height * 0.1,
                        width: size.width * 0.15,
                        child: Image.network(
                          // check if the media class is null then
                          data.data![index].user!.medium! != null
                              ? data.data![index].user!.medium!.url!
                              : "",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(AppConstants.getSnackBar(() {
                ref.watch(chatProvider);
              }));
            }
            return null;
          },
          loading: () => const Center(
                child: CircularProgressIndicator(
                  color: KColors.secondaryColor,
                ),
              ),
          error: (_, __) {
            return null;
          }),

      //   ZIMKitConversationListView(
      // errorBuilder: (context, defaultWidget) => const Text("Error"),
      // loadingBuilder: (context, defaultWidget) => const Center(
      //   child: CircularProgressIndicator(
      //     color: KColors.secondaryColor,
      //   ),
      // ),
      // itemBuilder: (context, conversation, _) {
      //   return ListTile(
      //     onTap: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: ((context) => ZIMKitMessageListPage(
      //                 conversationID: conversation.id,
      //                 conversationType: conversation.type,
      //               )),
      //         ),
      //       );
      //     },
      //     // dense: true,
      //     title: Text(
      //       conversation.name,
      //       style: const TextStyle(
      //         color: KColors.black,
      //         fontWeight: FontWeight.bold,
      //       ),
      //     ),
      //     subtitle: Text(
      //       conversation.lastMessage!.textContent!.text,
      //       style: const TextStyle(
      //         color: KColors.darkGrey,
      //       ),
      //     ),
      //     trailing: ZegoSendCallInvitationButton(
      //       //buttonSize: size,
      //       isVideoCall: false,
      //       resourceID: "zegouikit_call",
      //       onPressed: onSendCallInvitationFinished,
      //       invitees: [
      //         ZegoUIKitUser(
      //           id: conversation.id,
      //           name: conversation.name,
      //         ),
      //       ],
      //     ),
      //     // Text(
      //     //   conversation.unreadMessageCount == 0
      //     //       ? ""
      //     //       : conversation.unreadMessageCount.toString(),
      //     //   style: const TextStyle(
      //     //     fontWeight: FontWeight.bold,
      //     //     color: Colors.red,
      //     //   ),
      //     // ),
      //     leading: ClipRRect(
      //       borderRadius: BorderRadius.circular(12),
      //       child: SizedBox(
      //         height: size.height * 0.1,
      //         width: size.width * 0.15,
      //         child: Image.asset(
      //           "assets/images/client.png",
      //           fit: BoxFit.fill,
      //         ),
      //       ),
      //     ),
      //   );
      // },
      // onPressed: (context, conversation, defaultAction) {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: ((context) => ZIMKitMessageListPage(
      //             conversationID: conversation.id,
      //             conversationType: conversation.type,
      //             appBarBuilder: (context, defaultAppBar) {
      //               return AppBar(
      //                 backgroundColor: KColors.primaryColor,
      //                 title: Row(
      //                   mainAxisSize: MainAxisSize.min,
      //                   children: [
      //                     CircleAvatar(
      //                       child: conversation.avatarUrl.isNotEmpty
      //                           ? Image.network(conversation.avatarUrl)
      //                           : const Icon(FeatherIcons.user),
      //                     ),
      //                     const SizedBox(
      //                       width: 8,
      //                     ),
      //                     Text(
      //                       conversation.name,
      //                       style: const TextStyle(
      //                         color: KColors.black,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 leading: IconButton(
      //                   onPressed: () {
      //                     Navigator.pop(context);
      //                   },
      //                   icon: const Icon(
      //                     Icons.arrow_back_ios_new,
      //                     color: KColors.black,
      //                   ),
      //                 ),
      //                 actions: [
      //                   //==============================>>> call button.
      //                   IconButton(
      //                     onPressed: () {
      //                       var config = ZegoRoomConfig.defaultConfig();
      //                       config.token = Keys.token;
      //                       var user = ZegoUser(
      //                         ref.watch(userProvider).id!,
      //                         ref.watch(userProvider).name!,
      //                       );
      //                       ZegoExpressEngine.instance.loginRoom(
      //                         conversation.id,
      //                         user,
      //                         config: config,
      //                       );
      //                       // Navigator.push(
      //                       //   context,
      //                       //   MaterialPageRoute(
      //                       //     builder: (context) => VoiceCallScreen(
      //                       //       callID: conversation.id,
      //                       //       userID: conversation.id,
      //                       //       userName: conversation.name,
      //                       //     ),
      //                       //   ),
      //                       // );
      //                       ZegoSendCallInvitationButton(
      //                         isVideoCall: true,
      //                         resourceID:
      //                             "zegouikit_call", // For offline call notification
      //                         invitees: [
      //                           ZegoUIKitUser(
      //                             id: conversation.id,
      //                             name: conversation.name,
      //                           ),
      //                         ],
      //                       );
      //                     },
      //                     icon: const Icon(
      //                       FeatherIcons.phone,
      //                       color: KColors.black,
      //                     ),
      //                   ),
      //                   //================================>>video call.
      //                   IconButton(
      //                     onPressed: () {
      //                       Navigator.push(
      //                         context,
      //                         MaterialPageRoute(
      //                           builder: (context) => VideoCallScreen(
      //                             callID: conversation.id,
      //                           ),
      //                         ),
      //                       );
      //                     },
      //                     icon: const Icon(
      //                       FeatherIcons.video,
      //                       color: KColors.black,
      //                     ),
      //                   )
      //                 ],
      //               );
      //             },
      //             inputDecoration: const InputDecoration(
      //               border: InputBorder.none,
      //             ),
      //           )),
      //     ),
      //   );
      // },
    );
  }
}
