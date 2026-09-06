import 'package:equatable/equatable.dart';
import 'package:paperwings/clients/plane_transport.dart';

abstract class ConnectEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlaneClientConnect extends ConnectEvent {
  final PlaneTransport transport;

  PlaneClientConnect(this.transport);

  @override
  List<Object?> get props => [transport];
}

class PlaneClientConnected extends ConnectEvent {}

class PlaneClientDisconnected extends ConnectEvent {}