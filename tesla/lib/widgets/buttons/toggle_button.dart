import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  final Widget child;
  final Function(bool) onTab;
  double? width;
  double? height;
  final bool isOn;

  ToggleButton({
    this.width,
    this.height,
    required this.onTab,
    required this.isOn,
    required this.child,
  });

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool isOn = false;

  @override
  void initState() {
    //this.isOn = this.widget.isOn ?? true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.widget.width ?? 180.0,
      height: this.widget.height ?? 180.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(isOn
              ? "assets/images/button_on.png"
              : "assets/images/button_off.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            isOn = !isOn;
          });
          this.widget.onTab(isOn);
        },
        child: Align(
          alignment: Alignment.center,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              isOn ? Colors.white : Colors.grey.withOpacity(0.4),
              BlendMode.modulate,
            ),
            child: this.widget.child,
          ),
        ),
      ),
    );
  }
}
