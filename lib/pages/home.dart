import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:object_3d/bloc/fly_bloc/fly_bloc.dart';
import 'package:object_3d/bloc/plane_carousel_bloc/plane_carousel_bloc.dart';
import 'package:object_3d/bloc/recordings_bloc/recordings_bloc.dart';
import 'package:object_3d/clients/mock_tcp_client.dart';
import 'package:object_3d/clients/tcp_client_interface.dart';
import 'package:object_3d/models/menu_item.dart';
import 'package:object_3d/pages/mechanics.dart';
import 'package:object_3d/pages/planes.dart';
import 'package:object_3d/pages/fly.dart';
import 'package:object_3d/pages/recorder.dart';
import 'package:object_3d/pages/settings.dart';
import 'package:object_3d/widgets/tabbar.dart';
import 'package:provider/provider.dart';
import '../clients/tcp_client.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ITcpClient>(
          //create: (context) => MockTcpClient(),
          create: (context) => TcpClient(host: '192.168.4.1', port: 3333),
        ),
        BlocProvider<PlaneCarouselBloc>(
          create: (context) => PlaneCarouselBloc(
            client: context.read<ITcpClient>(),
          ),
        ),
        BlocProvider<FlyBloc>(
          create: (context) => FlyBloc(
            client: context.read<ITcpClient>(),
          ),
        ),
        BlocProvider<RecordedFlightsBloc>(
          create: (context) => RecordedFlightsBloc(),
        ),
      ],
      child: MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Color _currentColor;

  final List<MenuItem> menuItems = [
    MenuItem(
      title: "HANGAR",
      color: Colors.purple.shade800,
      icon: Icons.send,
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
      color: Colors.cyan.shade900,
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
    _currentColor = menuItems[_tabController.index].color;

    _tabController.addListener(() {
      setState(() {
        _currentColor = menuItems[_tabController.index].color;
      });
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
              setState(() {
                _tabController.animateTo(index);
              });
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          // Fondo que cambia y se desplaza con el TabBarView
          TweenAnimationBuilder<Color?>(
            tween: ColorTween(
              begin: menuItems[_tabController.previousIndex].color,
              end: menuItems[_tabController.index].color,
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
                            Colors.white.withOpacity(0.3),
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
              const SizedBox(
                  height: 125), // Ajustar espacio para el AppBar invisible
              Text(
                menuItems[_tabController.index].title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    PlaneCarousel(),
                    Fly(),
                    RecordedFlightsWidget(),
                    Mechanics(),
                    Settings(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
