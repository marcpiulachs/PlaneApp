import 'package:flutter/material.dart';
import 'package:plane_app/screens/home_screen/components/status_card.dart';

import '../../../constant.dart';

class StatusPanel extends StatelessWidget {
  const StatusPanel();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Status",
            style: TextStyle(
              fontSize: 20.0,
              color: mainTextColor,
            ),
          ),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: StatusCard(
                  title: "MANEUVER",
                  value: "54%",
                  icon: "assets/svgs/battery.svg",
                ),
              ),
              Expanded(
                child: StatusCard(
                  title: "SPEED",
                  value: "297km",
                  icon: "assets/svgs/range.svg",
                ),
              ),
              Expanded(
                child: StatusCard(
                  title: "ENDURANCE",
                  value: "27°C",
                  icon: "assets/svgs/temperature.svg",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
