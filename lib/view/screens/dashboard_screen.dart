// ignore_for_file: unused_result

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kotha/controller/connection_controllers/connection_controller.dart';
import 'package:kotha/controller/data_providers/app_height_provider.dart';
import 'package:kotha/model/constance/color_constant.dart';
import 'package:kotha/view/screens/home_screen.dart';
import 'package:kotha/view/screens/messenger/messenger_screen.dart';
import 'package:kotha/view/screens/my_favourite_screen.dart';
import 'package:kotha/view/screens/profile/user_profile_screen.dart';

import '../../controller/connection_controllers/connection_future_controller.dart';
import '../../controller/convo_controller/chat_controller.dart';

class DeshBoardScreen extends ConsumerStatefulWidget {
  const DeshBoardScreen({super.key});
  static const id = "/dashboardScreen";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeshBoardScreenState();
}

class _DeshBoardScreenState extends ConsumerState<DeshBoardScreen> {
  int _selectedIndex = 0;
  PageController pageController = PageController(initialPage: 0);
  final GlobalKey bottomNavigationBarKey = GlobalKey();

  //store the bottom navigation bar height to the state.
  _storeNavBarHeight() {
    ref.read(bottomNavBarHeightProvider).setHeight(bottomNavigationBarKey);
  }

  final _screens = [
    const HomeScreen(),
    const MyFavouriteScreen(),
    const MessengerScreen(),
    const UserProfileScreen()
  ];

  void _selectCurrentTab(int index) {
    //TODO: check if the state error is gone.
    // setState(() {
    //   _selectedIndex = index;
    // });
    _selectedIndex = index;
    pageController.animateToPage(_selectedIndex,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOutCubicEmphasized);
  }

  @override
  void initState() {
    _storeNavBarHeight();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        pageSnapping: true,
        onPageChanged: (value) {
          if (value == 3) {
            ref.watch(connectionProvider).getUserProfileData();
          } else if (value == 0) {
            ref.refresh(homeProvider);
          } else if (value == 1) {
            ref.refresh(likedUserProvider);
          } else if (value == 2) {
            ref.refresh(chatProvider);
          }
          setState(() {
            _selectedIndex = value;
          });
        },
        controller: pageController,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
          key: bottomNavigationBarKey,
          currentIndex: _selectedIndex,
          unselectedItemColor: KColors.grey,
          selectedItemColor: KColors.secondaryColor,
          onTap: _selectCurrentTab,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                ),
                label: "Favorite"),
            BottomNavigationBarItem(
                icon: Icon(
                  FeatherIcons.messageCircle,
                ),
                label: "Chat"),
            BottomNavigationBarItem(
                icon: Icon(
                  FeatherIcons.user,
                ),
                label: "Profile")
          ]),
    );
  }
}
