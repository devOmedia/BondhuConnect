import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kotha/model/constance/color_constant.dart';

class UserItemCard extends ConsumerStatefulWidget {
  const UserItemCard({
    super.key,
    this.isFev = true,
    required this.name,
    required this.age,
    required this.image,
  });
  final bool isFev;
  final String name;
  final int age;
  final String? image;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserItemCardState();
}

class _UserItemCardState extends ConsumerState<UserItemCard> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    bool isFev = widget.isFev;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            widget.image ??
                "https://t4.ftcdn.net/jpg/04/75/01/23/360_F_475012363_aNqXx8CrsoTfJP5KCf1rERd6G50K0hXw.jpg",
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [
                  KColors.primaryColor,
                  KColors.grey,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                //tileMode: TileMode.mirror,
              ),
              color: const Color(0xFF78797A).withOpacity(0.2),
            ),
            child: Row(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // usr name and online status.
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: size.width * 0.04,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.greenAccent,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Online',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                //========================>>  icons buttons
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isFev = !isFev;
                        });
                      },
                      child: Icon(
                        Icons.favorite,
                        color: isFev ? Colors.red : Colors.white,
                        size: size.width * 0.06,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        FeatherIcons.messageCircle,
                        color: Colors.white,
                        size: size.width * 0.06,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
