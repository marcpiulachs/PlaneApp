import 'package:equatable/equatable.dart';

abstract class ConnectEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlaneClientConnect extends ConnectEvent {}

class PlaneClientConnected extends ConnectEvent {}

class PlaneClientDisconnected extends ConnectEvent {}
