import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paperwings/clients/plane_transport.dart';

/// Opción de transporte mostrada en la pantalla de conexión, con la
/// información de UI asociada (etiqueta, icono e instrucciones).
class PlaneTransportOption {
  final PlaneTransport transport;
  final String label;
  final IconData icon;
  final List<String> instructions;

  /// Si la opción está disponible para el usuario. El mock solo lo está en
  /// builds de debug.
  final bool enabled;

  const PlaneTransportOption({
    required this.transport,
    required this.label,
    required this.icon,
    required this.instructions,
    this.enabled = true,
  });

  static const wifi = PlaneTransportOption(
    transport: PlaneTransport.wifi,
    label: 'WiFi',
    icon: Icons.wifi,
    instructions: [
      'Check your plane is turned ON.',
      'Ensure you are connected to the WiFi network created by your plane.',
      'Verify you have your phone cellular data turned OFF.',
    ],
  );

  static const ble = PlaneTransportOption(
    transport: PlaneTransport.ble,
    label: 'BT',
    icon: Icons.bluetooth,
    instructions: [
      'Turn ON Bluetooth on your phone.',
      'Check your plane is turned ON.',
      'Keep the plane close to your phone.',
      'Accept the Bluetooth permission when requested.',
    ],
  );

  static const mock = PlaneTransportOption(
    transport: PlaneTransport.mock,
    label: 'Mock',
    icon: Icons.science,
    enabled: kDebugMode,
    instructions: [
      'Simulation mode: no plane required.',
      'Telemetry and controls run locally for testing.',
    ],
  );

  static const all = [wifi, ble, mock];
}