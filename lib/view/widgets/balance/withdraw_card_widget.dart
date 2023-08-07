import 'package:flutter/material.dart';
import 'package:kotha/model/constance/color_constant.dart';

class WidthDrawCardWidget extends StatelessWidget {
  const WidthDrawCardWidget({
    super.key,
    required this.data,
  });

  final data;

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
      child: ListTile(
        leading: Image.asset(
            "assets/logo/upay.png"), // SvgPicture.asset("assets/logo/upay.svg"),
        title: Text(
          data.bankName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "৳ ${data!.amount}",
              style: const TextStyle(
                color: KColors.secondaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              data.receiveTime ?? "",
              style: const TextStyle(color: KColors.grey),
            )
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "A/C No : *** **** ${data.accountNumber.substring((data.accountNumber.length - 4).clamp(0, data.accountNumber.length))}",
              style: const TextStyle(
                color: KColors.grey,
              ),
            ),
            const Text(
              "Time     : 17:20",
              style: TextStyle(
                color: KColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
