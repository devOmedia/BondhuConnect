// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kotha/controller/connection_controllers/authentiacation_controller/authentication_controller.dart';
import 'package:kotha/model/constance/color_constant.dart';
import 'package:kotha/model/constance/constant.dart';
import 'package:kotha/model/local_db/user_data.dart';
import 'package:kotha/model/utils/validator.dart';
import 'package:kotha/view/screens/authentications/login_screen.dart';
import 'package:kotha/view/widgets/custom_text_inputfield.dart';
import 'package:motion_toast/motion_toast.dart';

import '../../widgets/otp_dialog.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});
  static const id = "/signupscreen";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  late TextEditingController _name;
  late TextEditingController _phoneNumber;
  late TextEditingController _password;
  late TextEditingController _conformPassword;
  late TextEditingController _otpCtr;
  late TextEditingController _dobCtr;
  final GlobalKey<FormState> _form = GlobalKey();
  bool isAgree = false;
  List<String> gender = ["Male", "Female", "Other"];
  String? selectedGender;
  late String deviceID;
  bool isPasswordShow = false;

//get the device id.
  _getTheDeviceID() async {
    deviceID = await UserData.getDeviceID();
    print(deviceID);
  }

  @override
  void initState() {
    _name = TextEditingController();
    _phoneNumber = TextEditingController(text: "+880");
    _password = TextEditingController();
    _conformPassword = TextEditingController();
    _otpCtr = TextEditingController();
    _dobCtr = TextEditingController();
    _getTheDeviceID();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _conformPassword.dispose();
    _password.dispose();
    _phoneNumber.dispose();
    _otpCtr.dispose();
    _dobCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: (() {
          FocusScope.of(context).unfocus();
        }),
        child: SingleChildScrollView(
          child: Padding(
            padding: AppConstants.appPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //======================================>> title
                Text(
                  "Create an account",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                AppConstants.getSpace(size.height * 0.04),
                Form(
                  key: _form,
                  child: Column(
                    children: [
                      //==================>>> name fields
                      CustomTextField(
                        controller: _name,
                        labelText: "Full Name",
                        inputType: TextInputType.text,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          } else {
                            return "Please enter your full name";
                          }
                        },
                      ),
                      AppConstants.getSpace(size.height * 0.02),
                      //=====================>> phone number

                      phoneNumberInputField(size),
                      if (isPasswordShow)
                        AppConstants.getSpace(size.height * 0.02),
                      //====================>> date of birth field
                      if (isPasswordShow)
                        GestureDetector(
                          onTap: () async {
                            // DateTime? pickedDate = await showDatePicker(
                            //   context: context,
                            //   initialDate: DateTime.now(),
                            //   firstDate: DateTime(
                            //       1900), //DateTime.now() - not to allow to choose before today.
                            //   lastDate: DateTime.now(),
                            // );

                            // if (pickedDate != null) {
                            //   String formattedDate =
                            //       DateFormat('MM-dd-yyyy').format(pickedDate);

                            //   setState(() {
                            //     _dobCtr.text =
                            //         formattedDate; //set output date to TextField value.
                            //   });
                            // }
                          },
                          child: TextFormField(
                            controller: _dobCtr,
                            //enabled: false,
                            //readOnly: true,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Birthday",
                              // helperText: "MM-DD-YYYY",
                              hintText: "MM-DD-YYYY",
                              labelStyle: const TextStyle(color: KColors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                  color: KColors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                  color: KColors.grey,
                                ),
                              ),
                            ),
                            validator: (value) => validateDateOfBirth(value!),
                          ),
                        ),
                      // AppConstants.getSpace(size.height * 0.02),
                      // //===============================>>> gender
                      // Container(
                      //   width: size.width,
                      //   height: size.height * 0.09,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(12),
                      //     border: Border.all(color: KColors.grey),
                      //   ),
                      //   child: DropdownButtonHideUnderline(
                      //     child: ButtonTheme(
                      //       alignedDropdown: true,
                      //       child: DropdownButton(
                      //         hint: const Text(
                      //           "Gender",
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.normal,
                      //           ),
                      //         ),
                      //         value: selectedGender,
                      //         items: gender.map((String category) {
                      //           return DropdownMenuItem(
                      //             value: category,
                      //             child: Text(category),
                      //           );
                      //         }).toList(),
                      //         onChanged: (value) {
                      //           setState(() {
                      //             selectedGender = value;
                      //           });
                      //         },
                      //         style: Theme.of(context).textTheme.titleLarge,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      AppConstants.getSpace(size.height * 0.02),
                      //===============================>>> gender
                      DropdownButtonFormField(
                          items: gender.map((String category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: "Gender",
                            labelStyle: const TextStyle(color: KColors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: KColors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: KColors.grey,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please select gender.";
                            } else if (value.isNotEmpty) {
                              return null;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            selectedGender = value;
                          }),
                      AppConstants.getSpace(size.height * 0.02),
                      //====================>> password field
                      if (isPasswordShow)
                        CustomTextField(
                          controller: _password,
                          labelText: "Password",
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
                      //===================>>> confirm field
                      if (isPasswordShow)
                        CustomTextField(
                          controller: _conformPassword,
                          labelText: "Confirm Password",
                          inputType: TextInputType.visiblePassword,
                          inputAction: TextInputAction.done,
                          isPassword: true,
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              if (value == _password.text) {
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
                      // ============================================>>> terms and conditions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                  checkColor: KColors.primaryColor,
                                  activeColor: KColors.secondaryColor,
                                  value: isAgree,
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        isAgree = value!;
                                      },
                                    );
                                  }),
                              const Row(children: [
                                Text(
                                  "I agree to ",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "Terms & Conditions",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: KColors.secondaryColor,
                                  ),
                                )
                              ])
                            ],
                          ),
                        ],
                      ),
                      ref.watch(authenticationProvider).isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: KColors.secondaryColor,
                              ),
                            )
                          : CustomAuthButton(
                              size: size,
                              text: "Sign up",
                              onPressed: () async {
                                if (_form.currentState!.validate()) {
                                  if (isAgree) {
                                    //check the user is checked the t & c
                                    if (isPasswordShow) {
                                      //show the password.
                                      final user = await ref
                                          .read(authenticationProvider)
                                          .userSignUp({
                                        "name": _name.text,
                                        "phone": _phoneNumber.text,
                                        "dob": _dobCtr.text,
                                        "gender": selectedGender == "Male"
                                            ? "M"
                                            : "F",
                                        "password": _password.text,
                                        "confirm_password":
                                            _conformPassword.text,
                                      });
                                      if (user != null) {
                                        if (user.success == true) {
                                          //show the otp dialog .
                                          displayOTPInputDialog(
                                            context,
                                            _otpCtr,
                                            {
                                              "name": _name.text,
                                              "phone": _phoneNumber.text,
                                              "dob": _dobCtr.text,
                                              "gender": selectedGender == "Male"
                                                  ? "M"
                                                  : "F",
                                              "password": _password.text,
                                              "confirm_password":
                                                  _conformPassword.text,
                                              "deviceID": deviceID,
                                            },
                                            ref,
                                            isSignUp: true,
                                          );
                                        } else {
                                          MotionToast.error(
                                            description: Text(user.message!),
                                          ).show(context);
                                        }
                                      } else {
                                        MotionToast.error(
                                          description: const Text(
                                              "Something went wrong, Please try again"),
                                        ).show(context);
                                      }
                                    } else {
                                      final user = await ref
                                          .read(authenticationProvider)
                                          .userSignUp({
                                        "name": _name.text,
                                        "phone": _phoneNumber.text,
                                        "dob": _dobCtr.text,
                                        "gender": selectedGender == "Male"
                                            ? "M"
                                            : "F",
                                        "password": _password.text,
                                        "confirm_password":
                                            _conformPassword.text,
                                      });
                                      if (user != null) {
                                        if (user.success == true) {
                                          //show the otp dialog .
                                          displayOTPInputDialog(
                                            context,
                                            _otpCtr,
                                            {
                                              "name": _name.text,
                                              "phone": _phoneNumber.text,
                                              "gender": selectedGender == "Male"
                                                  ? "M"
                                                  : "F",
                                              "deviceID": deviceID,
                                            },
                                            ref,
                                            isSignUp: true,
                                          );
                                        } else {
                                          MotionToast.error(
                                            description: Text(user.message!),
                                          ).show(context);
                                        }
                                      } else {
                                        MotionToast.error(
                                          description: const Text(
                                              "Something went wrong, Please try again"),
                                        ).show(context);
                                      }
                                    }
                                  } else {
                                    //show wornning msg for the T&C error.
                                    MotionToast.warning(
                                            description: const Text(
                                                "To continue, you must agree to the terms and conditions."))
                                        .show(context);
                                  }
                                  //
                                }
                              }),
                      AuthtextButton(
                        size: size,
                        msg: "Already have an account ?",
                        buttonText: "Log In",
                        onTriger: () {
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.id);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget phoneNumberInputField(Size size) {
    return TextFormField(
      controller: _phoneNumber,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: KColors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: KColors.grey,
          ),
        ),
        labelText: "Phone Number",
        // hintText: "+880",
        labelStyle: const TextStyle(color: KColors.grey),
      ),
      validator: (value) {
        if (validatePhoneNumber(value!)) {
          return null;
        }
        return "Invalid Phone Number";
      },
      onChanged: (value) {
        if (value.contains("+880")) {
          print("+880");
          setState(() {
            isPasswordShow = false;
          });
        } else {
          print("with out +880");
          setState(() {
            isPasswordShow = true;
          });
        }
      },
    );
  }
}
