import 'dart:developer';
import 'package:flutter/cupertino.dart';

import 'color_values.dart';

class StarDisplay extends StatelessWidget {
  final int value;
  const StarDisplay({Key? key, this.value = 0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    log("Received Number $value");
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < value ? CupertinoIcons.star_fill : CupertinoIcons.star,
          color: ColorValues.mainColor,
          size: 16,
        );
      }),
    );
  }
}
