// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kotha/controller/data_providers/balance_provider/balance_prvider.dart';
import 'package:kotha/model/constance/color_constant.dart';
import 'package:kotha/view/screens/authentications/forget_password/reset_password_screen.dart';
import 'package:kotha/view/screens/authentications/login_screen.dart';
import 'package:kotha/view/screens/authentications/user_interest_screen.dart';
import 'package:kotha/view/screens/dashboard_screen.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../controller/connection_controllers/authentiacation_controller/authentication_controller.dart';
import '../../controller/connection_controllers/balance_controller.dart';
import '../../controller/data_providers/user_prvider.dart';

// set the isFP value to true is this opt dialog is validating the forget password value.
Future<void> displayOTPInputDialog(
  BuildContext context,
  TextEditingController otpCtr,
  dynamic data,
  WidgetRef ref, {
  isFP = false,
  isWithdraw = false,
  isSignUp = false,
  isLogin = false,
  isLoginWithOtp = false,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Stack(
        alignment: Alignment.center,
        children: [
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Center(child: Text('OTP Authentication')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "An authentication code has been sent to ${data['phone']}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                PinCodeTextField(
                  appContext: context,
                  pastedTextStyle: TextStyle(
                    color: Colors.green.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 60,
                    fieldWidth: 40,
                    inactiveFillColor:
                        KColors.grey, //KConstColors.primaryColor,
                    inactiveColor: Colors.white, //KConstColors.primaryColor,
                    selectedColor: KColors.grey,
                    selectedFillColor: Colors.white,
                    activeFillColor: KColors.grey,
                    activeColor: KColors.grey,
                  ),
                  cursorColor: Colors.black,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  controller: otpCtr,
                  keyboardType: TextInputType.number,
                  boxShadows: const [
                    // BoxShadow(
                    //   offset: Offset(0, 1),
                    //   color: Colors.black12,
                    //   blurRadius: 10,
                    // )
                  ],
                  onCompleted: (v) {},
                  onChanged: (value) {
                    print(value);
                  },
                ),
                GestureDetector(
                  onTap: () {
                    otpCtr.clear();
                    data.remove(
                        "otp"); // remove the otp key value to resent the code from the data.
                    ref.watch(authenticationProvider).userSignUp(data);
                  },
                  child: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: "Receive the code? "),
                        TextSpan(
                          text: 'Resend Code!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: KColors.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              CustomAuthButton(
                  size: MediaQuery.of(context).size,
                  text: "Next",
                  onPressed: () async {
                    if (otpCtr.text.isNotEmpty) {
                      data.addAll({"otp": otpCtr.text});
                      // validate sign up otp
                      if (isSignUp) {
                        final user = await ref
                            .watch(authenticationProvider)
                            .validateSignUpOTP(data);

                        if (user != null) {
                          if (user.success == true) {
                            // check if the otp is validate then go to then next screen.
                            Navigator.pushReplacementNamed(
                                context, UserInterestScreen.id);
                          } else {
                            //show the error message.
                            MotionToast.error(description: Text(user.message!))
                                .show(context);
                          }
                        } else {
                          //server error
                          MotionToast.error(
                                  description: const Text(
                                      "Something went wrong, please try again."))
                              .show(context);
                        }
                        print(data);
                      } else if (isWithdraw) {
                        //====================================================>>>>validate withdraw otp
                        final response = await ref
                            .watch(balanceProvider)
                            .validateWithdrawBalance(data);

                        if (response != null) {
                          if (response["success"] == true) {
                            MotionToast.success(
                                    description: Text(response["message"]))
                                .show(context);
                            ref
                                .watch(balanceProvider)
                                .getUserBalance(); // recall the api to get the update balance. as the user is withdraw the balance.
                            //change the state
                            //change the withdraw ui
                            ref.read(isWithDrawProvider.notifier).state =
                                !ref.read(isWithDrawProvider.notifier).state;
                            Navigator.pop(context);
                          } else {
                            MotionToast.warning(
                                    description: Text(response["message"]))
                                .show(context);
                          }
                        } else {
                          //server error
                          MotionToast.warning(
                                  description: const Text(
                                      "Something went wrong, please try again"))
                              .show(context);
                        }
                      } else if (isFP) {
                        print(data);
                        //=====================================================>>> validate forget password otp.

                        final response = await ref
                            .watch(authenticationProvider)
                            .validateForgetPasswordOTP(data);

                        if (response != null) {
                          if (response["success"] == true) {
                            // if success then navigate to the next screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ResetPasswordScreen(data: data),
                              ),
                            );
                          } else {
                            MotionToast.warning(
                                    description: Text(response["message"]))
                                .show(context);
                          }
                        } else {
                          //server error
                          MotionToast.warning(
                                  description: const Text(
                                      "Something went wrong, please try again"))
                              .show(context);
                        }
                      } else if (isLogin) {
                        final loggedData = await ref
                            .read(authenticationProvider)
                            .getUserLoggedInWithOTP(data);

                        if (loggedData != null) {
                          if (loggedData.success == true) {
                            //store the id and name to the state
                            ref.watch(userProvider).setData(
                                  ID: loggedData.data!.user!.id.toString(),
                                  Name: loggedData.data!.user!.name,
                                );
                            //navigate to the home screen
                            Navigator.pushNamed(context, DeshBoardScreen.id);
                          } else {
                            MotionToast.error(
                                    description: Text(loggedData.message!))
                                .show(context);
                          }
                        } else {
                          MotionToast.warning(
                                  description: const Text(
                                      "Something went wrong, please try again"))
                              .show(context);
                        }
                      } 
                    } else {
                      //show warning message if the controller is empty.
                      MotionToast.warning(
                              description: const Text(
                                  "Invalid otp, please enter a valid one."))
                          .show(context);
                    }
                  })
            ],
          ),
          if (ref.watch(authenticationProvider).isOtpLoading)
            const Positioned(
              child: Center(
                child: CircularProgressIndicator(
                  color: KColors.secondaryColor,
                ),
              ),
            ),
        ],
      );
    },
  );
}
