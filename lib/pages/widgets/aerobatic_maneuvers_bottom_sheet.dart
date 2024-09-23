import 'package:flutter/material.dart';
import 'package:object_3d/models/maneuver.dart';

class AerobaticManeuversBottomSheet extends StatelessWidget {
  final Function(int) onManeuverSelected;

  AerobaticManeuversBottomSheet({super.key, required this.onManeuverSelected});

  final List<Maneuver> maneuvers = [
    Maneuver(icon: Icons.loop, text: "Barrel Roll"),
    Maneuver(icon: Icons.ac_unit, text: "Immelmann"),
    Maneuver(icon: Icons.rotate_90_degrees_ccw, text: "Cuban Eight"),
    Maneuver(icon: Icons.sync_alt, text: "Split S"),
    Maneuver(icon: Icons.u_turn_left, text: "Loop"),
    Maneuver(icon: Icons.u_turn_right, text: "Loop2"),
    Maneuver(icon: Icons.flight_takeoff, text: "Wingover"),
    Maneuver(icon: Icons.flight_land, text: "Snap Roll"),
    Maneuver(icon: Icons.star, text: "Vertical"),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(32.0),
        topRight: Radius.circular(32.0),
      ),
      child: Container(
        color: Colors.black, // Fondo negro
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "AEROBATIC MANEUVERS",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            const SizedBox(height: 30.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: maneuvers.length,
                itemBuilder: (context, index) {
                  final maneuver = maneuvers[index];
                  return GestureDetector(
                    onTap: () {
                      // Llamar al callback con el índice
                      onManeuverSelected(index);
                      // Cerrar el BottomSheet
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[800], // Recuadro gris oscuro
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            maneuver.icon,
                            color: Colors.blue,
                            size: 40.0, // Icono grande
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            maneuver.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
