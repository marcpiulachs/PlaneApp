import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/connect_bloc/connect_bloc.dart';
import 'package:paperwings/bloc/fly_bloc/fly_bloc.dart';
import 'package:paperwings/bloc/home_bloc/home_bloc.dart';
import 'package:paperwings/bloc/ota_bloc/ota_bloc.dart';
import 'package:paperwings/bloc/plane_carousel_bloc/plane_carousel_bloc.dart';
import 'package:paperwings/bloc/recordings_bloc/recordings_bloc.dart';
import 'package:paperwings/clients/mock_plane_client.dart';
import 'package:paperwings/clients/tcp_plane_client.dart';
import 'package:paperwings/clients/plane_client_interface.dart';
import 'package:paperwings/pages/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<IPlaneClient>(
          //create: (context) => MockPlaneClient(),
          create: (context) => TcpPlaneClient(host: '192.168.4.1', port: 3333),
        ),
        BlocProvider<PlaneCarouselBloc>(
          create: (context) => PlaneCarouselBloc(
            client: context.read<IPlaneClient>(),
          ),
        ),
        BlocProvider<FlyBloc>(
          create: (context) => FlyBloc(
            client: context.read<IPlaneClient>(),
          ),
        ),
        BlocProvider<OtaBloc>(
          create: (context) => OtaBloc(
            client: context.read<IPlaneClient>(),
          ),
        ),
        BlocProvider<RecordedFlightsBloc>(
          create: (context) => RecordedFlightsBloc(),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
        ),
        BlocProvider<ConnectBloc>(
          create: (context) => ConnectBloc(
            client: context.read<IPlaneClient>(),
          ),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}
