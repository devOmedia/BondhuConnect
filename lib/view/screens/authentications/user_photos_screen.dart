// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kotha/controller/connection_controllers/upload_media_controller.dart';
import 'package:kotha/controller/data_providers/authentication_provider.dart';
import 'package:kotha/model/constance/color_constant.dart';
import 'package:kotha/model/constance/constant.dart';
import 'package:kotha/view/screens/authentications/login_screen.dart';
import 'package:kotha/view/screens/dashboard_screen.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:video_player/video_player.dart';

class UserPhotosScreen extends ConsumerStatefulWidget {
  const UserPhotosScreen({super.key});
  static const id = "/userProfileScreen";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserPhotosScreenState();
}

class _UserPhotosScreenState extends ConsumerState<UserPhotosScreen> {
  late VideoPlayerController _controller;

  getImage(int imageOrder) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      switch (imageOrder) {
        case 1:
          ref.read(authProvider).setFirstImage(File(pickedFile.path));
          break;
        case 2:
          ref.read(authProvider).setSecondImage(File(pickedFile.path));
          break;
        case 3:
          ref.read(authProvider).setThirdImage(File(pickedFile.path));
          break;
        case 4:
          ref.read(authProvider).setForthImage(File(pickedFile.path));
          break;
        default:
          ref.read(authProvider).setFivethImage(File(pickedFile.path));
      }
      //upload the image to the backend
      final response = await ref
          .watch(mediaProvider)
          .uploadMedia("image", File(pickedFile.path));
      if (response != null) {
        if (response.success == true) {
          // store the image id to the provider
          ref.read(authProvider).setMediaID(imageOrder, response.data!.id!);
          MotionToast.success(description: Text(response.message!))
              .show(context);
        } else {
          // show the error message
          MotionToast.error(description: Text(response.message!)).show(context);
        }
      } else {
        // server error.
        MotionToast.error(
                description:
                    const Text("Something went wrong, please try again"))
            .show(context);
      }
    }
  }

  getVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      ref.read(authProvider).setVideo(File(pickedFile.path));
      _controller = VideoPlayerController.file(File(pickedFile.path))
        ..initialize().then((_) {
          _controller.play();
          setState(() {});
        });

      //upload the video to the backend
      final response = await ref
          .watch(mediaProvider)
          .uploadMedia("video", File(pickedFile.path));
      if (response != null) {
        if (response.success == true) {
          ref
              .read(authProvider)
              .setMediaID(0, response.data!.id!); // store the video id.
          MotionToast.success(description: Text(response.message!))
              .show(context);
        } else {
          // show the error message
          MotionToast.error(description: Text(response.message!)).show(context);
        }
      } else {
        // server error.
        MotionToast.error(
                description:
                    const Text("Something went wrong, please try again"))
            .show(context);
      }
    }
  }

//delete the media file.
  deleteMedia(int imageOrder) async {
    ref.read(authProvider).deleteMedia(imageOrder);

    final id = ref.watch(authProvider).mediaID[imageOrder];

    final response = await ref.watch(mediaProvider).deleteMedia(id ?? "");
    if (response != null) {
      if (response["success"] == true) {
        MotionToast.success(description: Text(response["message"]))
            .show(context);
      } else {
        // show the error message
        MotionToast.error(description: Text(response["message"])).show(context);
      }
    } else {
      // server error.
      MotionToast.error(
              description: const Text("Something went wrong, please try again"))
          .show(context);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final provider = ref.watch(authProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: AppConstants.appPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // back button.
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: size.width * 0.1,
                  height: size.height * 0.06,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: KColors.grey),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                  ),
                ),
              ),
              AppConstants.getSpace(size.width * 0.02),
              Text(
                "Add Photos & Video",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.06,
                ),
              ),
              AppConstants.getSpace(size.width * 0.04),
              //===============================>>> first image row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //================================>> first image
                  //check if the image provider has data if so then show the image
                  ref.watch(authProvider).firstImage != null
                      ? imageWidget(
                          size: size,
                          image: ref.watch(authProvider).firstImage!,
                          onPressed: () async {
                            await deleteMedia(1); // re choose the image file.
                          })
                      : imageTakerWidget(
                          size: size,
                          onPressed: () async {
                            await getImage(1);
                          }),
                  //==================================>>> second image
                  ref.watch(authProvider).secondImage != null
                      ? imageWidget(
                          size: size,
                          image: ref.watch(authProvider).secondImage!,
                          onPressed: () async {
                            await deleteMedia(2);
                          })
                      : imageTakerWidget(
                          size: size,
                          onPressed: () async {
                            await getImage(2);
                          }),
                ],
              ),
              AppConstants.getSpace(size.width * 0.04),
              //=======================================================>>> second image row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //=====================================================>>> third image
                  ref.watch(authProvider).thirdImage != null
                      ? imageWidget(
                          size: size,
                          image: ref.watch(authProvider).thirdImage!,
                          onPressed: () async {
                            await deleteMedia(3);
                          })
                      : imageTakerWidget(
                          size: size,
                          onPressed: () async {
                            await getImage(3);
                          }),
                  //=========================================================>>> forth image
                  ref.watch(authProvider).forthImage != null
                      ? imageWidget(
                          size: size,
                          image: ref.watch(authProvider).forthImage!,
                          onPressed: () async {
                            await deleteMedia(4);
                          })
                      : imageTakerWidget(
                          size: size,
                          onPressed: () async {
                            await getImage(4);
                          }),
                ],
              ),
              AppConstants.getSpace(size.width * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //===================================================>>> five image
                  ref.watch(authProvider).fivethImage != null
                      ? imageWidget(
                          size: size,
                          image: ref.watch(authProvider).fivethImage!,
                          onPressed: () async {
                            await deleteMedia(5);
                          })
                      : imageTakerWidget(
                          size: size,
                          onPressed: () async {
                            await getImage(5);
                          }),
                  //==========================================>>> video
                  ref.watch(authProvider).video != null
                      ? showVideo(
                          size: size,
                          onPressed: () {
                            deleteMedia(0);
                          },
                        )
                      : videoTakerWidget(
                          size: size,
                          onPressed: () async {
                            await getVideo();
                            log("i am");
                          }),
                ],
              ),
              //===========================================>>> button.
              AppConstants.getSpace(size.width * 0.08),
              CustomAuthButton(
                  size: size,
                  text: "Done",
                  onPressed: () {
                    //checking if all image are uploaded.
                    if (provider.firstImage != null ||
                        provider.secondImage != null ||
                        provider.thirdImage != null ||
                        provider.forthImage != null ||
                        provider.fivethImage != null ||
                        provider.video != null) {
                      Navigator.pushReplacementNamed(
                          context, DeshBoardScreen.id);
                    } else {
                      MotionToast.warning(
                              description: const Text(
                                  "Please upload the media files to continue"))
                          .show(context);
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget imageWidget({size, image, onPressed}) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: size.width * 0.44,
          height: size.height * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
              image: FileImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          child: GestureDetector(
            onTap: onPressed,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: KColors.secondaryColor,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget showVideo({size, onPressed}) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          width: size.width * 0.44,
          height: size.height * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: KColors.lightGrey,
          ),
          child: VideoPlayer(_controller),
        ),
        Positioned(
          child: GestureDetector(
            onTap: onPressed,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: KColors.secondaryColor,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget imageTakerWidget({size, onPressed, index}) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: size.width * 0.44,
          height: size.height * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: KColors.lightGrey,
          ),
          child: Center(
            child: Icon(
              Icons.image_outlined,
              color: Colors.white,
              size: size.width * 0.15,
            ),
          ),
        ),
        Positioned(
          child: GestureDetector(
            onTap: onPressed,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: KColors.secondaryColor,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  GestureDetector videoTakerWidget({size, onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: size.width * 0.44,
            height: size.height * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: KColors.lightGrey,
            ),
            child: Center(
              child: Icon(
                Icons.video_file,
                color: Colors.white,
                size: size.width * 0.15,
              ),
            ),
          ),
          Positioned(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: KColors.secondaryColor,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
