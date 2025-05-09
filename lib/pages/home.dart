import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/home_bloc/home_bloc.dart';
import 'package:paperwings/bloc/home_bloc/home_event.dart';
import 'package:paperwings/bloc/home_bloc/home_state.dart';
import 'package:paperwings/models/menu_item.dart';
import 'package:paperwings/pages/mechanics.dart';
import 'package:paperwings/pages/planes.dart';
import 'package:paperwings/pages/fly.dart';
import 'package:paperwings/pages/recorder.dart';
import 'package:paperwings/pages/settings.dart';
import 'package:paperwings/widgets/tabbar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<MenuItem> menuItems = [
    MenuItem(
      title: "HANGAR",
      color: Colors.purple.shade800,
      icon: Icons.home,
    ),
    MenuItem(
      title: "COPKIT",
      color: Colors.blue,
      icon: Icons.flight_takeoff,
    ),
    MenuItem(
      title: "FLIGHT RECORDER",
      color: Colors.red.shade900,
      icon: Icons.voicemail,
    ),
    MenuItem(
      title: "MECHANICS",
      color: Colors.teal.shade700,
      icon: Icons.handyman,
    ),
    MenuItem(
      title: "SETTINGS",
      color: Colors.green.shade700,
      icon: Icons.settings,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: menuItems.length, vsync: this);

    // Usamos BlocListener para escuchar cambios de tab en el Bloc
    _tabController.addListener(() {
      context.read<HomeBloc>().add(HomeTabChangedEvent(_tabController.index));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Sin sombra ni título
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: AnimatedTabBar(
            tabController: _tabController,
            menuItems: menuItems,
            onTabSelected: (index) {
              context.read<HomeBloc>().add(HomeTabChangedEvent(index));
              //setState(() {
              //  _tabController.animateTo(index);
              //});
            },
          ),
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoadedState) {
            // Asegúrate de ejecutar el cambio después del build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_tabController.index != state.currentTabIndex) {
                _tabController.animateTo(state.currentTabIndex);
              }
            });
            return Stack(
              children: [
                // Fondo que cambia y se desplaza con el TabBarView
                TweenAnimationBuilder<Color?>(
                  tween: ColorTween(
                    // Usamos el estado anterior
                    begin: menuItems[state.previousTabIndex].color,
                    // Usamos el estado actual
                    end: menuItems[state.currentTabIndex].color,
                  ),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, color, child) {
                    return Container(
                      color: color,
                      child: Center(
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Container(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.white.withValues(alpha: 0.3),
                                  Colors.transparent,
                                ],
                                radius: 0.5,
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),
                // Contenido del TabBarView
                Column(
                  children: [
                    const SizedBox(height: 125),
                    Text(
                      menuItems[state.currentTabIndex].title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: const [
                          Planes(),
                          Fly(),
                          RecordedFlights(),
                          Mechanics(),
                          Settings(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const Center();
          }
        },
      ),
    );
  }
}
