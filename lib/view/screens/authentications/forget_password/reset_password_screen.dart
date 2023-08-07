// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kotha/controller/connection_controllers/authentiacation_controller/authentication_controller.dart';
import 'package:kotha/model/constance/constant.dart';
import 'package:kotha/view/screens/authentications/login_screen.dart';
import 'package:kotha/view/widgets/custom_text_inputfield.dart';
import 'package:motion_toast/motion_toast.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key, required this.data});
  static const id = "/resetpassword";
  final Map data;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  late TextEditingController _passwordCtr;
  late TextEditingController _conformPasswordCtr;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    _passwordCtr = TextEditingController();
    _conformPasswordCtr = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passwordCtr.dispose();
    _conformPasswordCtr.dispose();
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
          padding: AppConstants.appPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Reset your password",
                  style: Theme.of(context).textTheme.headlineSmall),
              AppConstants.getSpace(size.height * 0.06),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _passwordCtr,
                      labelText: 'Password',
                      inputType: TextInputType.visiblePassword,
                      isPassword: true,
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        }
                        return "Invalid password. Please enter a valid password";
                      },
                    ),
                    AppConstants.getSpace(size.height * 0.02),
                    CustomTextField(
                      controller: _conformPasswordCtr,
                      labelText: 'Confirm Password',
                      inputType: TextInputType.visiblePassword,
                      isPassword: true,
                      inputAction: TextInputAction.done,
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          if (value == _passwordCtr.text) {
                            // check the password are same
                            return null;
                          } else {
                            return "Password did not matched";
                          }
                        }
                        return "Invalid password. Please enter a valid password";
                      },
                    ),
                    AppConstants.getSpace(size.height * 0.06),
                    CustomAuthButton(
                      size: size,
                      text: "Confirm",
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final response = await ref
                              .watch(authenticationProvider)
                              .resetPassword({
                            "phone": widget.data["phone"],
                            "otp": widget.data["otp"],
                            "password": _passwordCtr.text,
                            "confirm_password": _conformPasswordCtr.text,
                          });

                          if (response != null) {
                            if (response["success"] == true) {
                              Navigator.pushReplacementNamed(
                                  context, LoginScreen.id);
                            } else {
                              MotionToast.error(
                                description: Text(response["message"]),
                              ).show(context);
                            }
                          } else {
                            //server error
                            MotionToast.error(
                                    description: const Text(
                                        "Something went wrong, please try again"))
                                .show(context);
                          }
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
