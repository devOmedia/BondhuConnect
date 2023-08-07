import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kotha/controller/connection_controllers/setting_controller/setting_controller.dart';
import 'package:kotha/model/constance/color_constant.dart';
import 'package:kotha/model/constance/constant.dart';
import 'package:kotha/view/widgets/policy_widget.dart';

class TermsAndCondition extends ConsumerStatefulWidget {
  const TermsAndCondition({super.key});
  static const id = "termsAndConditions";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TermsAndConditionState();
}

class _TermsAndConditionState extends ConsumerState<TermsAndCondition> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: KColors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Terms & Conditions",
          style: TextStyle(
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.bold,
            color: KColors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          AppConstants.screenBackgroundColor(),
          ref.watch(SettingProvider("term")).when(
              data: (data) {
                if (data != null) {
                  return ListView.builder(
                      itemCount: data.data!.length,
                      itemBuilder: (context, index) {
                        return PolicyWidget(
                          data: data,
                          index: index,
                        );
                      });
                } else {
                  return const SizedBox();
                }
              },
              error: (e, __) {
                return const SizedBox();
              },
              loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: KColors.secondaryColor,
                    ),
                  ))
        ],
      ),
    );
  }
}
