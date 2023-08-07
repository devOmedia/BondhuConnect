import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//get the app bar height
final appBarHeight = StateProvider<double>((ref) {
  return PreferredSize(
    preferredSize: AppBar().preferredSize,
    child: AppBar(),
  ).preferredSize.height;
});

//get the bottom navigation bar height.
// final bottomNavBarHeightProvider =
//     StateProvider.family<double, GlobalKey>((ref, bottomNavigationBarKey) {
//   return bottomNavigationBarKey.currentContext!
//       .findRenderObject()!
//       .paintBounds
//       .height;
// });

class BottomNavBarHeight {
  late GlobalKey bottomNavigationBarKey;

  setHeight(GlobalKey key) {
    bottomNavigationBarKey = key;
  }

  getHeight() {
    return bottomNavigationBarKey.currentContext!
        .findRenderObject()!
        .paintBounds
        .height;
  }
}

final bottomNavBarHeightProvider = StateProvider<BottomNavBarHeight>((ref) {
  return BottomNavBarHeight();
});
