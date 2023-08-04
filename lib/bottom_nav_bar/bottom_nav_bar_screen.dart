import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_app/screens/favourite_screen.dart';

import '../screens/home_screen.dart';
import '../utilities/color_values.dart';
import '../utilities/pixels.dart';
import '../utilities/utility.dart';

class BottomNavBarScreen extends StatelessWidget {
  BottomNavBarScreen({Key? key}) : super(key: key);

  final List _pages = [const HomeScreen(), const FavouriteScreen()];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: ColorValues.whiteColor,
          body:
              Obx(() => _pages[Utility.btmNavBarController.selectedTab.value]),
          bottomNavigationBar: Obx(() => Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: ColorValues.grey2Color, width: 1),
                  ),
                ),
                child: BottomNavigationBar(
                    currentIndex: Utility.btmNavBarController.selectedTab.value,
                    onTap: (index) => _changeTab(index),
                    selectedItemColor: ColorValues.mainColor,
                    unselectedItemColor: ColorValues.darkTextColor,
                    selectedFontSize: Pixels.xxSmallTextSize,
                    unselectedFontSize: Pixels.xxSmallTextSize,
                    showUnselectedLabels: true,
                    backgroundColor: ColorValues.whiteColor,
                    type: BottomNavigationBarType.fixed,
                    items: [
                      BottomNavigationBarItem(
                          icon: Icon(
                            Icons.movie_filter_outlined,
                            size: 24,
                            color: (Utility
                                    .btmNavBarController.selectedTab.value
                                    .isEqual(0))
                                ? ColorValues.mainColor
                                : ColorValues.darkTextColor,
                          ),
                          label: "Discover"),
                      BottomNavigationBarItem(
                          icon: Icon(
                            Icons.favorite,
                            size: 24,
                            color: (Utility.btmNavBarController.selectedTab.value.isEqual(1))
                                ? ColorValues.mainColor
                                : ColorValues.darkTextColor,
                          ),
                          label: "Favorites"),
                    ]),
              )),
        );
      },
    );
  }

  _changeTab(int index) {
    Utility.btmNavBarController.selectedTab.value = index;
  }
}
