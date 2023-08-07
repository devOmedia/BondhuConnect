// ignore_for_file: use_build_context_synchronously

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kotha/model/constance/constant.dart';
import 'package:kotha/view/screens/authentications/login_screen.dart';
import 'package:kotha/view/widgets/aniated_toggle_button.dart';
import 'package:kotha/view/widgets/balance/balance_card_widget.dart';
import 'package:kotha/view/widgets/balance/earning_card.dart';
import 'package:kotha/view/widgets/balance/withdraw_card_widget.dart';
import 'package:kotha/view/widgets/custom_text_inputfield.dart';
import 'package:motion_toast/motion_toast.dart';

import '../../../controller/connection_controllers/balance_controller.dart';
import '../../../controller/data_providers/balance_provider/balance_prvider.dart';
import '../../../model/constance/color_constant.dart';
import '../../widgets/otp_dialog.dart';

class BalanceScreen extends ConsumerStatefulWidget {
  const BalanceScreen({super.key});
  static const id = "/balance";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends ConsumerState<BalanceScreen> {
  bool isEarning = false;
  bool isBalance = true;
  List<String> list = <String>['7 days', '10 days', '15 days'];
  String dropdownValue = "7 days";
  bool isWithDraw = false;
  late TextEditingController acNumberCtr;
  late TextEditingController balanceCtr;
  late TextEditingController passwordCtr;
  late TextEditingController topUpBalanceCtr;
  late TextEditingController _otpCtr;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    acNumberCtr = TextEditingController(text: "+880");
    balanceCtr = TextEditingController();
    passwordCtr = TextEditingController();
    _otpCtr = TextEditingController();
    topUpBalanceCtr = TextEditingController(text: "৳");
    super.initState();
  }

  @override
  void dispose() {
    acNumberCtr.dispose();
    balanceCtr.dispose();
    passwordCtr.dispose();
    topUpBalanceCtr.dispose();
    _otpCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final userBalance = ref.watch(balanceProvider).userBalanceModel;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(children: [
        //=====================================>>> balance button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              topBalanceButton(
                size: size,
                buttonText: "Earning",
                onPressed: () {
                  setState(() {
                    if (!isBalance) {
                      isEarning = !isEarning;
                      isBalance = !isBalance;
                    }
                  });
                },
                isSelected: isBalance,
              ),
              topBalanceButton(
                size: size,
                buttonText: "Balance",
                onPressed: () {
                  setState(() {
                    if (!isEarning) {
                      isEarning = !isEarning;
                      isBalance = !isBalance;
                    }
                  });
                },
                isSelected: isEarning,
              ),
            ],
          ),
        ),
        AppConstants.getSpace(size.height * 0.02),
        //===========================================balance card.
        currentBalanceInTKCardWidget(size: size, balance: userBalance),
        //=============================================>>>history
        SizedBox(height: size.height * 0.04),

        if (!isEarning) // earning widgets
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                color: Color(0xffF2F2F2),
              ),
              child: ref.watch(isWithDrawProvider)
                  ? withdrawPaymentInputFieldWidget(
                      size, userBalance.data!.amount!)
                  : historyWidget(size),
            ),
          )
        else //====================================>>>> balance button is true, topUp widgets
          BalanceCardWidgets(
            size: size,
          )
      ]),
    );
  }

  Widget withdrawPaymentInputFieldWidget(Size size, int balance) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      //change the state
                      //change the withdraw ui
                      ref.read(isWithDrawProvider.notifier).state =
                          !ref.read(isWithDrawProvider.notifier).state;

                      setState(() {
                        isWithDraw = false;
                      });
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: size.width * 0.04,
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.1,
                  ),
                  const Center(
                    child: Text("Don't have an Upay account?"),
                  ),
                ],
              ),
              AppConstants.getSpace(size.height * 0.01),
              // account create button.
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: KColors.secondaryColor),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.payment),
                      Text(
                        "Create an account",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: size.width * 0.04,
                          color: KColors.secondaryColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              AppConstants.getSpace(size.height * 0.04),
              CustomTextField(
                controller: acNumberCtr,
                labelText: "Enter Upay AC. number",
                inputType: TextInputType.number,
                validator: (value) {
                  if (value!.length > 4) {
                    return null;
                  } else {
                    return "Enter a valid ac. number";
                  }
                },
              ),
              AppConstants.getSpace(size.height * 0.02),
              CustomTextField(
                controller: balanceCtr,
                labelText: "Enter Amount",
                inputAction: TextInputAction.done,
                inputType: TextInputType.number,
                validator: (value) {
                  if (value!.isNotEmpty) {
                    if (value.contains(".") ||
                        value.contains(",") ||
                        value.contains("-")) {
                      return "Please enter a valid amount";
                    } else {
                      if (int.parse(value) > balance) {
                        return "Insufficient balance";
                      }
                      return null;
                    }
                  } else {
                    return "Enter a valid amount";
                  }
                },
              ),
              AppConstants.getSpace(size.height * 0.02),
              // CustomTextField(
              //   controller: passwordCtr,
              //   labelText: "Enter Password",
              //   inputType: TextInputType.number,
              //   isPassword: true,
              //   inputAction: TextInputAction.done,
              // ),
              AppConstants.getSpace(size.height * 0.04),
              CustomAuthButton(
                size: size,
                text: "Confirm",
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final response =
                        await ref.watch(balanceProvider).withdrawBalance({
                      "bank_name": "Upay Bangladesh",
                      "account_number": acNumberCtr.text,
                      "amount": int.parse(balanceCtr.text)
                    });

                    if (response != null) {
                      if (response["success"] == true) {
                        displayOTPInputDialog(
                          context,
                          _otpCtr,
                          {
                            "bank_name": "Upay Bangladesh",
                            "account_number": acNumberCtr.text,
                            "amount": int.parse(balanceCtr.text)
                          },
                          ref,
                          isWithdraw: true,
                        );

                        MotionToast.success(
                                description: Text(response["message"]))
                            .show(context);
                      } else {
                        MotionToast.warning(
                                description: Text(response["message"]))
                            .show(context);
                      }
                    } else {
                      MotionToast.warning(
                              description: const Text(
                                  "Something went wrong, please try again latter."))
                          .show(context);
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Column historyWidget(Size size) {
    return Column(children: [
      // ==========================================>>>> header.
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "History",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size.height * 0.03,
            ),
          ),
          // =================================================>>> last days.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              border: Border.all(
                color: KColors.secondaryColor,
              ),
            ),
            child: DropdownButton<String>(
              value: dropdownValue,
              borderRadius: BorderRadius.circular(12),
              underline: const SizedBox(),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      //========================================================================>> taggle button
      AppConstants.getSpace(size.height * 0.02),

      AnimatedToggle(
        values: const ['Earning', 'Withdraw'],
        onToggleCallback: (index) {
          if (index == 0) {
            isWithDraw = false;
          } else {
            isWithDraw = true;
            ref.read(balanceProvider.notifier).getWithdrawHistory();
          }

          setState(() {});
        },
        backgroundColor: Colors.white,
      ),
      AppConstants.getSpace(size.height * 0.02),
      // ======================================================>>>card list
      isWithDraw
          // =====================================>>>withdraw card
          ? ref.watch(balanceProvider).withdrawHistoryModel.data != null
              ? Expanded(
                  child: ListView.builder(
                    itemCount: ref
                        .watch(balanceProvider)
                        .withdrawHistoryModel
                        .data!
                        .length,
                    itemBuilder: (context, index) {
                      //return const EarningCardWidget();
                      if (ref
                              .watch(balanceProvider)
                              .withdrawHistoryModel
                              .data !=
                          null) {
                        return WidthDrawCardWidget(
                          data: ref
                              .watch(balanceProvider)
                              .withdrawHistoryModel
                              .data![index],
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                              color: KColors.secondaryColor),
                        );
                      }
                    },
                  ),
                )
              : const Expanded(child: SizedBox())
          : Expanded(
              //=====================================>>>earning card
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  //return const EarningCardWidget();
                  return const EarningCardWidget();
                },
              ),
            )
    ]);
  }

  Padding currentBalanceInTKCardWidget({size, balance}) {
    convertSecondsToHMS(int seconds) {
      int minutes = (seconds % 3600) ~/ 60;

      return "$minutes min";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: size.width,
        //height: size.height * 0.2,
        decoration: BoxDecoration(
          color: KColors.balanceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: KColors.secondaryColor,
          ),
        ),
        child: isBalance
            ? Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Available Balance"),
                  Text(
                    "৳ ${balance.data.amount}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.06,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        // change state to true to have the payment ui.
                        ref.read(isWithDrawProvider.notifier).state = true;
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: KColors.secondaryColor,
                        ),
                        child: const Text(
                          "Withdraw",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            //===============================>>>> for balance buttons
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Available Balance",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppConstants.getSpace(size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: size.height * 0.1,
                        width: size.width * 0.25,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          border: Border.all(
                            color: KColors.secondaryColor,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              FeatherIcons.messageCircle,
                              color: KColors.secondaryColor,
                            ),
                            Text(
                              balance.data.sms.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: size.height * 0.1,
                        width: size.width * 0.25,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          border: Border.all(
                            color: KColors.secondaryColor,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              FeatherIcons.phoneCall,
                              color: KColors.secondaryColor,
                            ),
                            Text(
                              convertSecondsToHMS(balance.data.voice),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: size.height * 0.1,
                        width: size.width * 0.25,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          border: Border.all(
                            color: KColors.secondaryColor,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              FeatherIcons.video,
                              color: KColors.secondaryColor,
                            ),
                            Text(
                              convertSecondsToHMS(balance.data.video),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
      ),
    );
  }

  Widget topBalanceButton({size, onPressed, buttonText, isSelected}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: size.height * 0.06,
        width: size.width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? KColors.secondaryColor : Colors.white,
          border: Border.all(color: KColors.secondaryColor),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color:
                  !isSelected ? KColors.secondaryColor : KColors.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: size.width * 0.045,
            ),
          ),
        ),
      ),
    );
  }
}

