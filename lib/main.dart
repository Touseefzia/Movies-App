import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:movies_app/bottom_nav_bar/bottom_nav_bar_screen.dart';
import 'package:movies_app/database_drift/database.dart';
import 'package:movies_app/utilities/color_values.dart';
import 'package:movies_app/utilities/reusable_widgets.dart';
import 'package:movies_app/utilities/utility.dart';
import 'package:drift/drift.dart' as dr;

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<List<SortPreference>> checkSortPreferences() async {
    List<SortPreference> list = await Utility.database.fetchSortPreference();
    if (list.isEmpty) {
      var result = await Utility.database.insertSortPreference(const SortPreferencesCompanion(value: dr.Value("rating")));
      Utility.btmNavBarController.sortingPreference.value = "rating";
      log("Record inserted $result");
    } else {
      Utility.btmNavBarController.sortingPreference.value = list[0].value.toLowerCase();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: Container(
          color: ColorValues.whiteColor,
          child: FutureBuilder<List<SortPreference>>(
              future: checkSortPreferences(),
              builder: (ctx, AsyncSnapshot<List<SortPreference>> snapshot) {
                if (snapshot.hasData) {
                  return BottomNavBarScreen();
                } else {
                  return ReusableWidgets.loadingWidget(
                      text: "Please Wait", constraints: constraints);
                }
              }),
        ),
      );
    });
  }
}
