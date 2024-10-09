import 'package:flutter/material.dart';
import 'package:paperwings/models/maneuver.dart';

class Maneuvers extends StatelessWidget {
  final Function(int) onManeuverSelected;
  final int selectedSize = 0;
  Maneuvers({super.key, required this.onManeuverSelected});

  final List<Maneuver> maneuvers = [
    Maneuver(icon: Icons.loop, text: "Barrel Roll"),
    Maneuver(icon: Icons.ac_unit, text: "Immelmann"),
    Maneuver(icon: Icons.rotate_90_degrees_ccw, text: "Cuban Eight"),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          maneuvers.length,
          (index) => Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(3),
              onTap: () => onManeuverSelected(index),
              child: Container(
                height: 130,
                width: 100,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey[800], // Recuadro gris oscuro
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      maneuvers[index].icon,
                      color: Colors.blue,
                      size: 40.0, // Icono grande
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      maneuvers[index].text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 30.0, // Icono grande
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
