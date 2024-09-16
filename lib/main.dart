import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:object_3d/bloc/fly_bloc/fly_bloc.dart';
import 'package:object_3d/bloc/plane_carousel_bloc/plane_carousel_bloc.dart';
import 'package:object_3d/bloc/recordings_bloc/recordings_bloc.dart';
import 'package:object_3d/clients/tcp_plane_client.dart';
import 'package:object_3d/clients/plane_client_interface.dart';
import 'package:object_3d/widgets/circular.dart';
import 'package:object_3d/widgets/compass.dart';
import 'package:object_3d/pages/home.dart';
import 'package:object_3d/widgets/throttle.dart';
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
        BlocProvider<RecordedFlightsBloc>(
          create: (context) => RecordedFlightsBloc(),
        ),
      ],
      child: const MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}
