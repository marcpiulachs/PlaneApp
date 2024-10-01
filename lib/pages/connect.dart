import 'package:flutter/material.dart';
import 'package:paperwings/bloc/connect_bloc/connect_bloc.dart';
import 'package:paperwings/bloc/connect_bloc/connect_event.dart';
import 'package:paperwings/bloc/connect_bloc/connect_state.dart';
import 'package:paperwings/widgets/connecting.dart';
import 'package:paperwings/widgets/disconected.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Connect extends StatefulWidget {
  const Connect({super.key});

  @override
  State<Connect> createState() => _ConnectState();
}

class _ConnectState extends State<Connect> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectBloc, ConnectState>(
      builder: (context, state) {
        // Verifica el estado y muestra el widget adecuado
        if (state is ConnectPlaneConnecting) {
          return const Connecting();
        } else if (state is ConnectPlaneDisconnected) {
          return Disconnected(
            onConnect: () {
              context.read<ConnectBloc>().add(PlaneClientConnect());
            },
          );
        } else if (state is ConnectInitial) {
          return const Center();
        } else if (state is ConnectPlaneConnected) {
          return const Center();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
