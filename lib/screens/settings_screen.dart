import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_app/database_drift/database.dart';
import '../utilities/color_values.dart';
import '../utilities/pixels.dart';
import '../utilities/reusable_widgets.dart';
import '../utilities/utility.dart';
import 'package:drift/drift.dart' as dr;

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);
  final TAG = "SettingsScreen";

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: ColorValues.whiteColor,
          appBar: ReusableWidgets.appBarWidget(
              context: context,
              title: "Settings",
              onBackPress: (){Get.back();}),
          body: Padding(
            padding: const EdgeInsets.only(left: Pixels.screenPadding, right: Pixels.screenPadding),
            child: ListView(
              children: [
              ReusableWidgets.textWidget(alignment: TextAlign.start, fontWeight: FontWeight.bold,text: "Sort by", textColor: ColorValues.darkTextColor, fontSize: Pixels.normalTextSize),
              Obx(() =>
              Column(
                children: [
                  RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.trailing,
                    title: const Text("Popularity"),
                    value: "popularity",
                    groupValue: Utility.btmNavBarController.sortingPreference.value,
                    onChanged: (value){
                      Utility.btmNavBarController.sortingPreference.value = value.toString();
                    },
                  ),

                  RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.trailing,
                    title: const Text("Rating"),
                    value: "rating",
                    groupValue: Utility.btmNavBarController.sortingPreference.value,
                    onChanged: (value){
                      Utility.btmNavBarController.sortingPreference.value = value.toString();
                    },
                  ),

                  RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.trailing,
                    title: const Text("Newest First"),
                    value: "newest first",
                    groupValue: Utility.btmNavBarController.sortingPreference.value,
                    onChanged: (value){
                        Utility.btmNavBarController.sortingPreference.value = value.toString();
                    },
                  ),
                  RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.trailing,
                    title: const Text("Oldest First"),
                    value: "oldest first",
                    groupValue: Utility.btmNavBarController.sortingPreference.value,
                    onChanged: (value){
                        Utility.btmNavBarController.sortingPreference.value = value.toString();
                    },
                  )
                ],
              ),),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorValues.darkTextColor,
                    elevation: 0,
                  ),
                  onPressed: () async{
                    await Utility.database.deleteSortPreferences();
                    await Utility.database.insertSortPreference(SortPreferencesCompanion(value: dr.Value(Utility.btmNavBarController.sortingPreference.value)));
                    Utility.sortMovies();
                    Get.back();
                    },
                  child: ReusableWidgets.textWidget(text: "Save", textColor: ColorValues.whiteColor, fontSize: Pixels.normalTextSize),
                )
            ],
            ),
          ),

        );
      },
    );
  }

}
