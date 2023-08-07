import 'dart:developer';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kotha/controller/data_providers/convo_providers/chat_provider.dart';
import 'package:kotha/model/constance/color_constant.dart';
import 'package:kotha/view/screens/messenger/video_call_screen.dart';
import 'package:kotha/view/screens/messenger/voice_screen.dart';
import '../../../controller/convo_controller/chat_controller.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  const ConversationScreen({
    super.key,
    required this.id,
    required this.name,
    required this.photoUrl,
  });
  final String id;
  final String name;
  final String photoUrl;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  late TextEditingController _msgCtr;
  bool isConvoHistoryStored = false; // handle the fist convo save

  @override
  void initState() {
    _msgCtr = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _msgCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final convoData = ref.watch(convoHistoryProvider).convoList;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KColors.primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: KColors.black,
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            //user image
            CircleAvatar(
              backgroundColor: KColors.primaryColor,
              child: ClipRRect(
                child: Image.network(
                  widget.photoUrl,
                  height: size.width,
                  width: 100.0,
                ),
              ),
            ),
            Text(
              widget.name.split(" ")[0],
              style: const TextStyle(color: KColors.black),
            )
          ],
        ),
        actions: [
          // ZegoSendCallInvitationButton(
          //   isVideoCall: true,
          //  // resourceID: "zegouikit_call", // For offline call notification
          //   invitees: [
          //     ZegoUIKitUser(
          //       id: widget.id,
          //       name: widget.name,
          //     ),
          //   ],
          // ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VoiceCallScreen(
                    callID: widget.id,
                    userID: widget.id,
                    userName: widget.name,
                  ),
                ),
              );
            },
            icon: const Icon(
              FeatherIcons.phone,
              color: KColors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoCallScreen(
                    callID: widget.id,
                    userID: widget.id,
                    userName: widget.name,
                  ),
                ),
              );
            },
            icon: const Icon(
              FeatherIcons.video,
              color: KColors.black,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ref.watch(chatDetailsProvider(widget.id)).when(
                    data: (data) {
                      if (isConvoHistoryStored == false) {
                        //store all conversations
                        //when the screen is first loaded.
                        ref
                            .read(convoHistoryProvider)
                            .setInitConvo(data!.data!.conversations!);

                        isConvoHistoryStored = true;
                      }

                      log(convoData.length.toString());

                      return ListView.builder(
                        itemCount: convoData.length,
                        itemBuilder: (context, index) {
                          return Align(
                            child: Text(
                              convoData[index].content!,
                              style: const TextStyle(
                                color: KColors.secondaryColor,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    error: (_, __) {
                      return const SizedBox();
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: KColors.secondaryColor,
                      ),
                    ),
                  ),
            ),
            // Expanded(
            //   child: ZIMKitConversationListView(
            //     onPressed: (context, conversation, defaultAction) {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: ((context) => const ZIMKitMessageListPage(
            //               conversationID: ConversationScreen.id)),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            //const ZIMKitMessageInput(conversationID: "7"),
            msgSendWidget(size),
          ],
        ),
      ),
    );
  }

  Row msgSendWidget(Size size) {
    return Row(
      children: [
        SizedBox(
          width: size.width * 0.15,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: KColors.lightGrey,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.add,
                  color: KColors.black,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Container(
            margin: const EdgeInsets.only(left: 8, right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: size.height * 0.08,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              border: Border.all(
                color: KColors.lightGrey,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _msgCtr,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Type something",
                    ),
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        //=======================>>>>send button
        SizedBox(
          width: size.width * 0.15,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: KColors.secondaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.send,
                  color: KColors.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
