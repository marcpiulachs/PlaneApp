import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane_app/constant.dart';
import 'package:plane_app/screens/home_screen/home_screen_page.dart';
import 'package:plane_app/screens/lock_screen/components/car_component.dart';
import 'package:plane_app/screens/lock_screen/components/title.dart';
import 'package:plane_app/widgets/buttons/lock_button.dart';
import 'package:plane_app/widgets/buttons/nav_button.dart';
import 'package:plane_app/widgets/scaffolds/base_scaffold.dart';

class LockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBarContent: [
        NavButton(
          width: 100.0,
          height: 100.0,
          child: SvgPicture.asset(
            "assets/svgs/page_one_setting icon.svg",
            width: 17.0,
            height: 17.0,
          ),
        ),
      ],
      body: Column(
        children: [
          LockScreenTitle(
            upperTitle: "plane_app",
            title: "Cybertruck",
          ),
          Expanded(
            child: CarComponent(
              carSpeed: "297",
            ),
          ),
          Text(
            "A/C is turned on",
            style: TextStyle(
              color: lightTextColor,
              fontSize: 20.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          LockButton(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
            child: Image.asset(
              "assets/images/page_one_lock.png",
              width: 60.0,
              height: 60.0,
            ),
          ),
          Text(
            "Tap to open the car",
            style: TextStyle(
              color: mainTextColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
