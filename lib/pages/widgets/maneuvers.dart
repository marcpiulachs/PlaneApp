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
                height: 110,
                width: 110,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black, // Recuadro gris oscuro
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      maneuvers[index].icon,
                      color: Colors.blue,
                      size: 40.0, // Icono grande
                    ),
                    const SizedBox(height: 5),
                    Text(
                      maneuvers[index].text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.center,
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
