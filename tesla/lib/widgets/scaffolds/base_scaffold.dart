import 'package:flutter/material.dart';

import '../../constant.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  List<Widget> appBarContent;

  BaseScaffold({required this.body, required this.appBarContent}) {
    if (this.appBarContent == null) {
      this.appBarContent = [];
    }
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
        child: SafeArea(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              this.appBarContent.length > 0
                  ? Positioned(
                      top: -10.0,
                      left: -15.0,
                      right: -15.0,
                      height: 90.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: this.appBarContent,
                      ),
                    )
                  : Container(),
              Positioned(
                top: this.appBarContent.length > 0 ? 60.0 : 0.0,
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: body,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
