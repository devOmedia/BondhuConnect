// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kotha/controller/connection_controllers/authentiacation_controller/authentication_controller.dart';
import 'package:kotha/controller/data_providers/user_prvider.dart';
import 'package:kotha/model/constance/color_constant.dart';
import 'package:kotha/model/local_db/user_data.dart';
import 'package:kotha/model/utils/validator.dart';
import 'package:kotha/view/screens/authentications/forget_password/forget_pssword_phone_number_screen.dart';
import 'package:kotha/view/screens/authentications/signup_screen.dart';
import 'package:kotha/view/screens/dashboard_screen.dart';
import 'package:kotha/view/widgets/custom_text_inputfield.dart';
import 'package:kotha/view/widgets/otp_dialog.dart';
import 'package:motion_toast/motion_toast.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  static const id = '/login';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _phoneCtr;
  late TextEditingController _passwordCtr;
  late final GlobalKey<FormState> _formKey = GlobalKey();
  bool isRemenberMe = false;
  late String deviceID;
  bool isPasswordShow = false;
  late TextEditingController _otpCtr;

  _getTheDeviceID() async {
    deviceID = await UserData.getDeviceID();
  }

  @override
  void initState() {
    _phoneCtr = TextEditingController(text: "+880");
    _passwordCtr = TextEditingController();
    _otpCtr = TextEditingController();
    _getTheDeviceID();
    super.initState();
  }

  @override
  void dispose() {
    _phoneCtr.dispose();
    _passwordCtr.dispose();
    _otpCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // app bar
                  Text(
                    "Log in your account",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: size.width * 0.06),
                  ),
                  SizedBox(height: size.height * 0.04),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _phoneCtr,
                          labelText: "Phone Number",
                          inputType: TextInputType.phone,
                          validator: (value) {
                            if (validatePhoneNumber(value!)) {
                              return null;
                            } else {
                              return "Invalid Phone Number.";
                            }
                          },
                          onChanged: (value) {
                            if (value.contains("+880")) {
                              //in bd;
                              setState(() {
                                isPasswordShow = false;
                              });
                            } else {
                              //outside bd
                              setState(() {
                                isPasswordShow = true;
                              });
                            }
                          },
                        ),
                        SizedBox(height: size.height * 0.02),
                        if (isPasswordShow)
                          CustomTextField(
                            controller: _passwordCtr,
                            inputAction: TextInputAction.done,
                            labelText: "Password",
                            inputType: TextInputType.visiblePassword,
                            isPassword: true,
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                return null;
                              } else {
                                return "Invalid Password.";
                              }
                            },
                          ),
                        SizedBox(height: size.height * 0.02),
                        // ============================================>>> password reset and remember buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                    checkColor: KColors.primaryColor,
                                    activeColor: KColors.secondaryColor,
                                    value: isRemenberMe,
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          isRemenberMe = value!;
                                        },
                                      );
                                    }),
                                const Text(
                                  "Remember Me",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context,
                                    ForgetPasswordPhoneNumberScreen.id);
                              },
                              child: const Text(
                                "Forgot Password ?",
                                style: TextStyle(
                                  color: KColors.secondaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                        //===============================>>> login button
                        SizedBox(height: size.height * 0.04),
                        ref.watch(authenticationProvider).isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: KColors.secondaryColor,
                                ),
                              )
                            : CustomAuthButton(
                                size: size,
                                text: "Log in",
                                onPressed: () async {
                                  FocusScope.of(context)
                                      .unfocus(); //unfocus the keyboard

                                  if (_formKey.currentState!.validate()) {
                                    if (isPasswordShow) {
                                      final loggedData = await ref
                                          .read(authenticationProvider)
                                          .getUserLoggedIn(
                                        {
                                          "phone": _phoneCtr.text,
                                          "password": _passwordCtr.text,
                                          "deviceID": deviceID,
                                        },
                                      );

                                      if (loggedData != null) {
                                        if (loggedData.success == true) {
                                          //store the id and name to the state
                                          ref.watch(userProvider).setData(
                                                ID: loggedData.data!.user!.id
                                                    .toString(),
                                                Name:
                                                    loggedData.data!.user!.name,
                                              );
                                          //navigate to the home screen
                                          Navigator.pushNamed(
                                              context, DeshBoardScreen.id);
                                        } else {
                                          MotionToast.error(
                                                  description:
                                                      Text(loggedData.message!))
                                              .show(context);
                                        }
                                      } else {
                                        MotionToast.warning(
                                                description: const Text(
                                                    "Something went wrong, please try again"))
                                            .show(context);
                                      }
                                    } else {
                                      final response = await ref
                                          .watch(authenticationProvider)
                                          .sendUserLoggedOTP(
                                        {
                                          "phone": _phoneCtr.text,
                                          "deviceID": deviceID,
                                        },
                                      );

                                      if (response != null) {
                                        if (response["success"] == true) {
                                          //otp login.
                                          displayOTPInputDialog(
                                            context,
                                            _otpCtr,
                                            {
                                              "phone": _phoneCtr.text,
                                              "deviceID": deviceID,
                                            },
                                            ref,
                                            isLogin: true,
                                          );
                                          MotionToast.success(
                                            description:
                                                Text(response["message"]),
                                          ).show(context);
                                        } else {
                                          MotionToast.warning(
                                            description:
                                                Text(response["message"]),
                                          ).show(context);
                                        }
                                      } else {
                                        MotionToast.warning(
                                          description: const Text(
                                              "Something went wrong, please try again"),
                                        ).show(context);
                                      }
                                    }
                                  }
                                },
                              ),
                        //=========================================>>> signin
                        AuthtextButton(
                          size: size,
                          msg: "Don't have an account ?",
                          buttonText: "Sign Up",
                          onTriger: () {
                            Navigator.pushReplacementNamed(
                                context, SignupScreen.id);
                          },
                        ),
                        //==========================================>>> social auth
                        // DefaultTextStyle(
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.w600,
                        //     fontSize: size.width * 0.035,
                        //     color: KColors.grey,
                        //   ),
                        //   child: Column(
                        //     children: const [
                        //       Text("OR"),
                        //       Text("Sign in with:"),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(height: size.height * 0.02),
                        //======================================= google auth
                        // GestureDetector(
                        //   onTap: () {
                        //     ref.read(googleAuthProvider).signInWithGoogle();
                        //   },
                        //   child: Container(
                        //     padding: const EdgeInsets.all(8),
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(8),
                        //       border: Border.all(color: KColors.grey),
                        //     ),
                        //     child: SizedBox(
                        //       width: size.width * 0.08,
                        //       child:
                        //           Image.asset("assets/social_auth/google.png"),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAuthButton extends StatelessWidget {
  const CustomAuthButton({
    Key? key,
    required this.size,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final Size size;
  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: size.height * 0.08,
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: KColors.secondaryColor,
        ),
        child: Center(
            child: Text(
          text,
          style: TextStyle(
            color: KColors.primaryColor,
            fontWeight: FontWeight.w400,
            fontSize: size.width * 0.045,
          ),
        )),
      ),
    );
  }
}

class AuthtextButton extends StatelessWidget {
  const AuthtextButton({
    Key? key,
    required this.msg,
    required this.buttonText,
    required this.onTriger,
    required this.size,
  }) : super(key: key);

  final String msg;
  final String buttonText;
  final Function onTriger;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          msg,
          style: TextStyle(
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          onPressed: () {
            onTriger();
          },
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.w600,
              color: KColors.secondaryColor,
            ),
          ),
        )
      ],
    );
  }
}
