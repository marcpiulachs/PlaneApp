// Definir el estado del PlaneCarouselBloc
import 'package:equatable/equatable.dart';

abstract class ConnectState extends Equatable {
  @override
  List<Object> get props => [];
}

class ConnectInitial extends ConnectState {}

class ConnectPlaneConnected extends ConnectState {}

class ConnectPlaneConnecting extends ConnectState {}

class ConnectPlaneDisconnected extends ConnectState {}
