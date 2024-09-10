import 'package:flutter/material.dart';
import 'package:plane_app/constant.dart';
import 'package:plane_app/widgets/buttons/toggle_button.dart';

class ModeOption extends StatelessWidget {
  final String name;
  final Widget icon;

  const ModeOption({required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(
            color: lightTextColor,
            fontWeight: FontWeight.w900,
            fontSize: 16.0,
          ),
        ),
        Container(
          width: 85.0,
          height: 85.0,
          margin: EdgeInsets.only(top: 5.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -30.0,
                right: -30.0,
                left: -30.0,
                bottom: -30.0,
                child: ToggleButton(
                  child: this.icon,
                  isOn: false,
                  onTab: (p0) => {},
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
