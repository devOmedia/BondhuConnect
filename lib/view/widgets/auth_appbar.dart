import 'package:flutter/material.dart';
import 'package:kotha/model/constance/color_constant.dart';

class AuthAppBar extends StatelessWidget {
  const AuthAppBar({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Let's Sign You In",
          style: TextStyle(
            fontSize: size.width * 0.08,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          "Welcome back, you’ve\nbeen missed!",
          style: TextStyle(
            color: KColors.grey,
            fontSize: size.width * 0.045,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }
}
