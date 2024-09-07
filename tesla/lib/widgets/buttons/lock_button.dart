import 'package:flutter/material.dart';

class LockButton extends StatelessWidget {
  final Widget child;
  final Function onTap;

  const LockButton({
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125.0,
      width: 125.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/lock_button.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: InkWell(
        //onTap: this.onTap,
        child: Align(
          alignment: Alignment.center,
          child: this.child,
        ),
      ),
    );
  }
}
