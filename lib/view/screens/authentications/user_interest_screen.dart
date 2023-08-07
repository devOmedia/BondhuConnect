// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kotha/controller/connection_controllers/authentiacation_controller/authentication_controller.dart';
import 'package:kotha/controller/connection_controllers/connection_future_controller.dart';
import 'package:kotha/model/constance/color_constant.dart';
import 'package:kotha/model/constance/constant.dart';
import 'package:kotha/view/screens/authentications/login_screen.dart';
import 'package:kotha/view/screens/authentications/user_photos_screen.dart';
import 'package:motion_toast/motion_toast.dart';

class UserInterestScreen extends ConsumerStatefulWidget {
  const UserInterestScreen({super.key});
  static const id = "/userInterestScreen";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserInterestScreenState();
}

class _UserInterestScreenState extends ConsumerState<UserInterestScreen> {
  final List _selectedInterest = [];

  //generate random color.
  Color getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: AppConstants.appPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //=============================>>> top back button.
              // Container(
              //   width: size.width * 0.1,
              //   padding: const EdgeInsets.all(8),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(8),
              //     border: Border.all(
              //       color: KColors.grey,
              //     ),
              //   ),
              //   child: const Center(
              //     child: Icon(Icons.arrow_back_ios_new),
              //   ),
              // ),
              AppConstants.getSpace(size.height * 0.02),
              Text(
                "Interest",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.08,
                ),
              ),
              const Text(
                "You can choose maximum 5(five) interests",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              AppConstants.getSpace(size.width * 0.04),
//====================================================================>>> interest list
              SizedBox(
                height: size.height * 0.62,
                child: ref.watch(interestProvider).when(
                  data: (interest) {
                    if (interest != null) {
                      return GridView.builder(
                          itemCount: interest.data!.length,
                          // shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 4.5,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                //check if the interest is less then 5, which is the max limit.
                                if (_selectedInterest.length != 5) {
                                  setState(() {
                                    //if the interest is already in the list then remove it to un select the item
                                    // if not then add the id to select the item.
                                    if (_selectedInterest
                                        .contains(interest.data![index].id)) {
                                      _selectedInterest
                                          .remove(interest.data![index].id);
                                    } else {
                                      _selectedInterest
                                          .add(interest.data![index].id);
                                    }
                                  });
                                } else {
                                  MotionToast.warning(
                                          description: const Text(
                                              "You have chosen 5 interest. can not select more."))
                                      .show(context);
                                }
                              },
                              child: interestCardWidget(
                                interest.data![index].name!,
                                _selectedInterest
                                        .contains(interest.data![index].id)
                                    ? getRandomColor()
                                    : Colors.white,
                                _selectedInterest
                                        .contains(interest.data![index].id)
                                    ? true
                                    : false,
                              ),
                            );
                          });
                    } else {
                      MotionToast.error(
                        description: const Text(
                            "Something went wrong, please try again"),
                      ).show(context);
                      return Container();
                    }
                  },
                  error: (e, __) {
                    return const SizedBox();
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: KColors.secondaryColor,
                      ),
                    );
                  },
                ),
              ),

              AppConstants.getSpace(size.width * 0.02),
              ref.watch(authenticationProvider).isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: KColors.primaryColor,
                      ),
                    )
                  : CustomAuthButton(
                      size: size,
                      text: "Next",
                      onPressed: () async {
                        final response = await ref
                            .watch(authenticationProvider)
                            .addUserInterest(
                          {
                            "data": _selectedInterest..sort(),
                          },
                        );

                        if (response != null) {
                          if (response["success"] == true) {
                            MotionToast.warning(
                                    description: Text(response["message"]))
                                .show(context);
                            Navigator.pushReplacementNamed(
                                context, UserPhotosScreen.id);
                          } else {
                            MotionToast.warning(
                                    description: Text(response["message"]))
                                .show(context);
                          }
                        } else {
                          //server error
                          MotionToast.warning(
                              description: const Text(
                                  "Something went wrong, Please try again"));
                        }
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }

  Container interestCardWidget(String interest, Color color, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color,
        border: Border.all(color: KColors.grey),
      ),
      child: Center(
          child: Text(
        interest,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : Colors.black,
        ),
      )),
    );
  }
}
