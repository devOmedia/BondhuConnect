import 'package:flutter/material.dart';
import 'package:kotha/model/constance/color_constant.dart';

class EarningCardWidget extends StatelessWidget {
  const EarningCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(
            color: KColors.secondaryColor,
          )),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //message
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //message
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Message    :  ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '100',
                    ),
                  ],
                ),
              ),
              //time
              Text("12-2-2012")
            ],
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Voice Call  :  ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '10 min',
                ),
              ],
            ),
          ),
          //video call
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //message
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Video Call  :  ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '10 min',
                    ),
                  ],
                ),
              ),
              //time
              Text(
                "৳ 10",
                style: TextStyle(
                  color: KColors.secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
