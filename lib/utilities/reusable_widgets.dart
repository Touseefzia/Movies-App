import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'color_values.dart';
import 'pixels.dart';


class ReusableWidgets {
  static String TAG = "ReusableWidgets";

  // Text("Welcome to LTSoccer\nYou are Coach or Athlete"),
  static Widget textWidget(
      {required String text,
      required Color textColor,
      required double fontSize,
      int? maxLine = 1,
      TextDecoration textDecoration = TextDecoration.none,
      TextAlign alignment = TextAlign.center,
      FontWeight fontWeight = FontWeight.normal}) {
    return Text(
      text,
      textAlign: alignment,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          decoration: textDecoration,
          fontWeight: fontWeight),
    );
  }



  static PreferredSizeWidget appBarWidget({
    required BuildContext context,
    required Function onBackPress,
    String? title,
    bool isBottomNavScreen = false,
    Widget? showIcon,
  }) {
    return AppBar(
      bottomOpacity: 0.0,
      elevation: 0.0,
      backgroundColor: ColorValues.whiteColor,
      leading: (isBottomNavScreen != true)? Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: ColorValues.darkTextColor,
            ),
            onPressed: () {
              onBackPress();
            },
          );
        },
      ): const SizedBox(),
      centerTitle: true,
      title: textWidget(text: title?? "",
        fontWeight: FontWeight.bold,
        fontSize: Pixels.smallTextSize,
        textColor: ColorValues.darkTextColor,
      ),
      actions: [
        IconButton(
                padding: EdgeInsets.zero,
                icon: showIcon ?? const SizedBox(),
                onPressed: () {},
              )
      ],
    );
  }


  static Widget loadingWidget(
      {required String text, required BoxConstraints constraints}) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(child: CircularProgressIndicator(color: ColorValues.mainColor,)),
            const SizedBox(
              height: 15,
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(5),
              child: ReusableWidgets.textWidget(
                  text: text,
                  textColor: ColorValues.mainColor,
                  fontSize: Pixels.smallTextSize),
            ),
          ],
        ),
      );
  }

  static Widget childButtonWidget(
      {required Function onButtonPress,
      required Widget child,
      ButtonStyle? style,
      // required OutlinedBorder shape,
      required Color bgColor}) {
    return Center(
      child: ElevatedButton(
        style: (style == null)
            ? ElevatedButton.styleFrom(
                backgroundColor: bgColor,
                foregroundColor: bgColor,
                // shape: shape,
                shadowColor: ColorValues.transparent,
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                elevation: 0,
                splashFactory: NoSplash.splashFactory)
            : style,
        onPressed: () {
          onButtonPress();
        },
        child: child,
      ),
    );
  }



  static Widget bottomNavItem(
      {required String image,
      required String label,
      required Color bgColor,
      required Color iconColor,
      required Function onTap,
      required double paddingBottom}) {
    return Expanded(
      flex: 1,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          backgroundColor: bgColor,
          shape: const BeveledRectangleBorder(),
          elevation: 0,
        ),
        onPressed: () {
          onTap();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: paddingBottom),
              child: Image.asset(
                "assets/$image.png",
                width: 24,
                height: 24,
                color: iconColor,
              ),
            ),
            Text(
              label,
              style:
                  TextStyle(color: iconColor, fontSize: Pixels.xxSmallTextSize),
            )
          ],
        ),
      ),
    );
  }

}