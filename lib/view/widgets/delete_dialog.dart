import 'package:flutter/material.dart';

import '../../model/constance/color_constant.dart';

Future<void> deleteDialog(BuildContext context) async {
  return showDialog(

      //barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          //backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: const Center(
            child: Text(
              "Are you sure you\nwait to delete your\naccount?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: KColors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Container(
                    height: 60,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: KColors.secondaryColor),
                    ),
                    child: const Center(
                      child: Text(
                        "No",
                        style: TextStyle(color: KColors.secondaryColor),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    height: 60,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: KColors.secondaryColor,
                    ),
                    child: const Center(
                      child: Text(
                        "Yes",
                        style: TextStyle(color: KColors.primaryColor),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        );
      });
}
