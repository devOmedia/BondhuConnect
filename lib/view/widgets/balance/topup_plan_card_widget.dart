import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:kotha/model/constance/color_constant.dart';

class TopUpPlanCardWidget extends StatelessWidget {
  const TopUpPlanCardWidget({
    super.key,
    required this.size,
    required this.topUpData,
    required this.balance,
  });

  final Size size;
  final Map topUpData;
  final int balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    FeatherIcons.messageCircle,
                    color: KColors.secondaryColor,
                  ),
                  const SizedBox(width: 16),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Messages:     ',
                          style: TextStyle(
                              color: KColors.lightGrey,
                              fontSize: size.width * 0.045),
                        ),
                        TextSpan(
                          text: topUpData["message"].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.045),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                "৳ $balance",
                style: TextStyle(
                    color: KColors.secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.065),
              )
            ],
          ),
          //==========================>>>>audio call
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                FeatherIcons.phoneCall,
                color: KColors.secondaryColor,
              ),
              const SizedBox(width: 16),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Voice call:     ',
                      style: TextStyle(
                          color: KColors.lightGrey,
                          fontSize: size.width * 0.045),
                    ),
                    TextSpan(
                      text: "${topUpData["voice"]} min",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.045),
                    ),
                  ],
                ),
              ),
            ],
          ),
          //====================================>>> video call
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    FeatherIcons.video,
                    color: KColors.secondaryColor,
                  ),
                  const SizedBox(width: 16),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Video call:     ',
                          style: TextStyle(
                              color: KColors.lightGrey,
                              fontSize: size.width * 0.045),
                        ),
                        TextSpan(
                          text: "${topUpData["video"]} min",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.045,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //=================================>>> buy now button
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: KColors.secondaryColor,
                  ),
                  child: const Text(
                    "Buy now",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
