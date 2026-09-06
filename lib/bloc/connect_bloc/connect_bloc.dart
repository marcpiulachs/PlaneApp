import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperwings/bloc/connect_bloc/connect_event.dart';
import 'package:paperwings/bloc/connect_bloc/connect_state.dart';
import 'package:paperwings/clients/client_manager.dart';

class ConnectBloc extends Bloc<ConnectEvent, ConnectState> {
  final ClientManager client;

  ConnectBloc({required this.client}) : super(ConnectInitial()) {
    // Suscripción a los callbacks del cliente
    client.onConnect.listen((_) {
      add(PlaneClientConnected());
    });
    client.onDisconnect.listen((_) {
      add(PlaneClientDisconnected());
    });
    client.onConnectionFailed.listen((_) {
      add(PlaneClientDisconnected());
    });

    on<PlaneClientConnect>((event, emit) async {
      emit(ConnectPlaneConnecting());
      await Future.delayed(const Duration(seconds: 1));
      // Crea (o reutiliza) el cliente del transporte seleccionado en la
      // pantalla de conexión y conecta con él.
      await client.use(event.transport);
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