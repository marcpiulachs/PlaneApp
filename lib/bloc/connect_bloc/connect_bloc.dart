import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:object_3d/bloc/connect_bloc/connect_event.dart';
import 'package:object_3d/bloc/connect_bloc/connect_state.dart';
import 'package:object_3d/clients/plane_client_interface.dart';

class ConnectBloc extends Bloc<ConnectEvent, ConnectState> {
  final IPlaneClient client;

  ConnectBloc({required this.client}) : super(ConnectInitial()) {
    // Suscripción a los callbacks del cliente
    client.onConnect = () {
      add(PlaneClientConnected());
    };
    client.onDisconnect = () {
      add(PlaneClientDisconnected());
    };
    client.onConnectionFailed = () {
      add(PlaneClientDisconnected());
    };

    on<PlaneClientConnect>((event, emit) async {
      emit(ConnectPlaneConnecting());
      await Future.delayed(const Duration(seconds: 1));
      await client.connect();
    });

    on<PlaneClientConnected>((event, emit) {
      emit(ConnectPlaneConnected());
    });

    on<PlaneClientDisconnected>((event, emit) {
      emit(ConnectPlaneDisconnected());
    });

    if (client.isConnected) {
      add(PlaneClientConnected());
    } else {
      add(PlaneClientDisconnected());
    }
  }
}
