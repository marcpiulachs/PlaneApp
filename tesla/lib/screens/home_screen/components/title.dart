import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constant.dart';

class HomeScreenTitle extends StatelessWidget {
  final String upperTitle;
  final String title;

  const HomeScreenTitle({
    required this.upperTitle,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          upperTitle,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
            color: lightTextColor,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w900,
            color: mainTextColor,
          ),
        )
      ],
    );
  }
}
