import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/connect_bloc/connect_bloc.dart';
import 'package:paperwings/bloc/flight_detail_bloc.dart';
import 'package:paperwings/bloc/fly_bloc/fly_bloc.dart';
import 'package:paperwings/bloc/home_bloc/home_bloc.dart';
import 'package:paperwings/bloc/mechanics_bloc/mechanics_bloc.dart';
import 'package:paperwings/bloc/motor_settings_bloc/motor_settings_bloc.dart';
import 'package:paperwings/bloc/orientation_bloc.dart';
import 'package:paperwings/bloc/ota_bloc/ota_bloc.dart';
import 'package:paperwings/bloc/plane_carousel_bloc/plane_carousel_bloc.dart';
import 'package:paperwings/bloc/plane_settings_bloc/plane_settings_bloc.dart';
import 'package:paperwings/bloc/recordings_bloc/recordings_bloc.dart';
import 'package:paperwings/bloc/sensor_bloc/sensor_bloc.dart';
import 'package:paperwings/bloc/calibration_bloc.dart';
import 'package:paperwings/repositories/plane_repository.dart';
import 'package:paperwings/clients/mock_plane_client.dart';
import 'package:paperwings/clients/tcp_plane_client.dart';
import 'package:paperwings/clients/plane_client_interface.dart';
import 'package:paperwings/pages/home.dart';
import 'package:paperwings/repositories/recorder_repository.dart';
import 'package:paperwings/config/app_theme.dart';
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
        BlocProvider<FlightDetailBloc>(
          create: (context) => FlightDetailBloc(
            repository: RecorderRepository(),
          ),
        ),
        Provider<EventBus>(
          create: (context) => EventBus(),
        ),
        Provider<IPlaneClient>(
          //create: (context) => MockPlaneClient(),
          create: (context) => TcpPlaneClient(host: '192.168.4.1', port: 3333),
        ),
        BlocProvider<SensorBloc>(
          create: (context) => SensorBloc(
            client: context.read<IPlaneClient>(),
          ),
        ),
        BlocProvider<FlyBloc>(
          create: (context) => FlyBloc(
            client: context.read<IPlaneClient>(),
            eventBus: context.read<EventBus>(),
          ),
          lazy: false,
        ),
        BlocProvider<MechanicsBloc>(
          create: (context) => MechanicsBloc(
            client: context.read<IPlaneClient>(),
          ),
        ),
        BlocProvider<OtaBloc>(
          create: (context) => OtaBloc(
            client: context.read<IPlaneClient>(),
          ),
        ),
        BlocProvider<MotorSettingsBloc>(
          create: (context) => MotorSettingsBloc(
            client: context.read<IPlaneClient>(),
          ),
        ),
        BlocProvider<RecordedFlightsBloc>(
          create: (context) => RecordedFlightsBloc(
            repository: RecorderRepository(),
          ),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
        ),
        BlocProvider<ConnectBloc>(
          create: (context) => ConnectBloc(
            client: context.read<IPlaneClient>(),
          ),
        ),
        BlocProvider(
          create: (context) => PlaneSettingsBloc(
            client: context.read<IPlaneClient>(),
            eventBus: context.read<EventBus>(),
          ),
          lazy: false,
        ),
        BlocProvider<PlaneCarouselBloc>(
          create: (context) => PlaneCarouselBloc(
            client: context.read<IPlaneClient>(),
            eventBus: context.read<EventBus>(),
            repository: PlaneRepository(),
          ),
          lazy: false,
        ),
        BlocProvider<CalibrationBloc>(
          create: (context) => CalibrationBloc(
            context.read<IPlaneClient>(),
          ),
        ),
        BlocProvider<OrientationBloc>(
          create: (context) =>
              OrientationBloc(client: context.read<IPlaneClient>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MyHomePage(),
      ),
    );
  }
}
