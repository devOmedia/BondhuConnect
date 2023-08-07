import 'package:flutter/material.dart';

class PolicyWidget extends StatelessWidget {
  const PolicyWidget({
    super.key,
    required this.data,
    required this.index,
  });

  final data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.data![index].name!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (index == 0)
            Text(
              data.data![index].content!,
              style: const TextStyle(
                color: Color(0xff666666),
              ),
            )
          else
            Text(
              "${data.data![index].content.isNotEmpty ? index : ''} ${data.data![index].content!}",
              style: const TextStyle(
                color: Color(0xff666666),
              ),
            ),
          //=========================================>>> nested
          if (data.data![index].nested!.isNotEmpty)
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.data![index].nested!.length,
                itemBuilder: (context, newIndex) {
                  return Text(
                    data.data![index].nested![newIndex].isNotEmpty
                        ? "$index.${newIndex + 1} ${data.data![index].nested![newIndex]}"
                        : "",
                    style: const TextStyle(
                      color: Color(0xff666666),
                    ),
                  );
                }),
          const SizedBox(
            width: 8,
          ),
          Text(
            data.data![index].ending ?? "",
            style: const TextStyle(
              color: Color(0xff666666),
              //fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
