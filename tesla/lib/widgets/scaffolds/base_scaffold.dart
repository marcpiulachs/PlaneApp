import 'package:flutter/material.dart';

import '../../constant.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  List<Widget> appBarContent;

  BaseScaffold({required this.body, required this.appBarContent}) {
    //if (this.appBarContent == null) {
    //  this.appBarContent = [];
    //}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: conBackgroundColor,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Text(("he")),
            /*
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: this.appBarContent,
            ),*/
            body
          ],
        ),
      ),
    );
  }
}
