// ignore_for_file: use_build_context_synchronously, unused_result

import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kotha/controller/connection_controllers/connection_controller.dart';
import 'package:kotha/controller/connection_controllers/connection_future_controller.dart';
import 'package:kotha/model/constance/color_constant.dart';
import 'package:kotha/view/widgets/user_item_card.dart';
import 'package:motion_toast/motion_toast.dart';

import '../../model/constance/constant.dart';
import '../widgets/user_bottom_sheet.dart';

class MyFavouriteScreen extends ConsumerStatefulWidget {
  const MyFavouriteScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MyFavouriteScreenState();
}

class _MyFavouriteScreenState extends ConsumerState<MyFavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    const options = LiveOptions(
      // Start animation after (default zero)
      delay: Duration(seconds: 1),

      // Show each item through (default 250)
      showItemInterval: Duration(milliseconds: 500),

      // Animation duration (default 250)
      showItemDuration: Duration(seconds: 1),

      // Animations starts at 0.05 visible
      // item fraction in sight (default 0.025)
      visibleFraction: 0.05,

      // Repeat the animation of the appearance
      // when scrolling in the opposite direction (default false)
      // To get the effect as in a showcase for ListView, set true
      reAnimateOnVisibility: false,
    );

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset("assets/logo/kotha_logo_1.svg"),
        ),
      ),
      body: Stack(
        children: [
          AppConstants.screenBackgroundColor(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ref.watch(likedUserProvider).when(data: (data) {
              if (data != null) {
                return LiveGrid.options(
                    options: options,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: size.height * 0.01,
                      crossAxisSpacing: size.width * 0.02,
                    ),
                    itemCount: data.data!.length,
                    itemBuilder: (ctx, index, animation) {
                      return GestureDetector(
                        onTap: () async {
                          final response = await ref
                              .watch(connectionProvider)
                              .getOtherUserModel(data.data![index].userId!);

                          if (response != null) {
                            if (response.success == true) {
                              // MotionToast.success(
                              //         description: Text(response.message!))
                              //     .show(context);
                              detailsBottomSheet(context, size, response);
                            } else {
                              MotionToast.warning(
                                      description: Text(response.message!))
                                  .show(context);
                            }
                          } else {
                            MotionToast.error(
                                    description: const Text(
                                        "Server error, Please try again later"))
                                .show(context);
                          }
                        },
                        child: UserItemCard(
                          name: data.data![index].profile!.name!
                              .trim()
                              .split(" ")[0],
                          age: 12,
                          image: data.data![index].profile!.photoUrl,
                        ),
                      );
                    });
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(AppConstants.getSnackBar(() {
                  ref.refresh(likedUserProvider);
                }));
                // MotionToast.warning(
                //         description: const Text(
                //             "Something went wrong, please try again"))
                //     .show(context);
              }
              return const SizedBox();
            }, error: (e, __) {
              return null;

              //return Text(e.toString());
            }, loading: () {
              return const Center(
                child: CircularProgressIndicator(
                  color: KColors.secondaryColor,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
