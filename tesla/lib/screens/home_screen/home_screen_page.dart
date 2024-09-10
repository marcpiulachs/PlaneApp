import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:plane_app/constant.dart';
import 'package:plane_app/screens/ac_screen/ac_screen_page.dart';
import 'package:plane_app/screens/home_screen/components/information_panel.dart';
import 'package:plane_app/screens/home_screen/components/navigation_history.dart';
import 'package:plane_app/screens/home_screen/components/status_panel.dart';
import 'package:plane_app/screens/home_screen/components/title.dart';
import 'package:plane_app/widgets/buttons/nav_button.dart';
import 'package:plane_app/widgets/scaffolds/base_scaffold.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 72, 1, 1),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: conBackgroundColor,
          ),
        ),
        child: new SafeArea(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: TabBar(
                  indicatorPadding: const EdgeInsets.all(0),
                  indicator: BoxDecoration(
                    color: buttonBakColor,
                    shape: BoxShape.circle,
                  ),
                  controller: tabController,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                  tabs: [
                    Tab(
                        icon: Icon(
                      Icons.place_outlined,
                      size: 40,
                    )),
                    Tab(
                        icon: Icon(
                      Icons.place_outlined,
                      size: 40,
                    )),
                    Tab(
                        icon: Icon(
                      Icons.directions_bike,
                      size: 40,
                    )),
                    Tab(
                        icon: Icon(
                      Icons.directions_transit,
                      size: 40,
                    )),
                    Tab(
                        icon: Icon(
                      Icons.directions_bike,
                      size: 40,
                    )),
                  ],
                ),
              ),
              HomeScreenTitle(
                upperTitle: "Plane APP",
                title: "HANGAR",
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: <Widget>[
                    Column(children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 200.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(height: 20.0),
                            Image.asset(
                              "assets/images/page_two_car.png",
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.center,
                            ),
                            Container(
                              child: StatusPanel(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: mainTextColor, // background
                                backgroundColor: buttonBakColor, // foreground
                              ),
                              onPressed: () {},
                              child: const Text(
                                'Fly!',
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    Center(),
                    Center(),
                    Center(),
                    Center(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
