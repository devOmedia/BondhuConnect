// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kotha/controller/connection_controllers/authentiacation_controller/authentication_controller.dart';
import 'package:kotha/model/constance/color_constant.dart';
import 'package:kotha/model/constance/constant.dart';
import 'package:kotha/model/local_db/user_data.dart';
import 'package:kotha/view/screens/authentications/login_screen.dart';
import 'package:kotha/view/widgets/custom_text_inputfield.dart';
import 'package:kotha/view/widgets/otp_dialog.dart';
import 'package:motion_toast/motion_toast.dart';

class ForgetPasswordPhoneNumberScreen extends ConsumerStatefulWidget {
  const ForgetPasswordPhoneNumberScreen({super.key});
  static const id = "/forgetPasswordPhoneNumberScreen";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgetPasswordPhoneNumberScreenState();
}

class _ForgetPasswordPhoneNumberScreenState
    extends ConsumerState<ForgetPasswordPhoneNumberScreen> {
  late TextEditingController _phoneCtr;
  late TextEditingController _otpCtr;
  final GlobalKey<FormState> _formKey = GlobalKey();
  late String deviceID;

  _getDeviceID() async {
    deviceID = await UserData.getDeviceID();
  }

  @override
  void initState() {
    _phoneCtr = TextEditingController(text: "+880");
    _otpCtr = TextEditingController();
    _getDeviceID();
    super.initState();
  }

  @override
  void dispose() {
    _phoneCtr.dispose();
    _otpCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: AppConstants.appPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //========================>>> back button.
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
                //====================================>>>
                AppConstants.getSpace(size.height * 0.04),
                Text("Forget Password",
                    style: Theme.of(context).textTheme.headlineSmall),
                AppConstants.getSpace(size.height * 0.1),
                //==========================================>>> phone number field
                Form(
                  key: _formKey,
                  child: CustomTextField(
                    controller: _phoneCtr,
                    labelText: "Phone number",
                    inputType: TextInputType.phone,
                    inputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.length < 11 || value.length > 14) {
                        return "Invalid phone number, please enter a valid one";
                      }

                      return null;
                    },
                  ),
                ),

                AppConstants.getSpace(size.height * 0.26),
                ref.watch(authenticationProvider).isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: KColors.secondaryColor),
                      )
                    : CustomAuthButton(
                        size: size,
                        text: "Continue",
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final data = await ref
                                .watch(authenticationProvider)
                                .getOTPForForgetPassword(
                                    {"phone": _phoneCtr.text});

                            if (data != null) {
                              //TODO: this is for test remove this.

                              if (data.success == true) {
                                //navigate to the next step
                                displayOTPInputDialog(
                                  context,
                                  _otpCtr,
                                  {
                                    "phone": _phoneCtr.text,
                                    "deviceID": deviceID,
                                  },
                                  ref,
                                  isFP: true,
                                );
                              } else {
                                //show the error message
                                MotionToast.error(
                                        description: Text(data.message!))
                                    .show(context);
                              }
                            } else {
                              //server error.
                              MotionToast.error(
                                      description: const Text(
                                          "Something went wrong, please try again"))
                                  .show(context);
                            }
                          }
                        }),
                //text button.
                AuthtextButton(
                  size: size,
                  msg: "Remember your password?",
                  buttonText: "Login",
                  onTriger: () {
                    Navigator.pushReplacementNamed(context, LoginScreen.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
