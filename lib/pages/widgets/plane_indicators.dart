import 'package:flutter/material.dart';
import 'package:paperwings/models/plane_item.dart';
import 'package:paperwings/widgets/circular.dart';

class PlaneIndicators extends StatelessWidget {
  const PlaneIndicators({
    super.key,
    required this.plane,
  });

  final PlaneItem plane;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          const Text(
            "FEATURES",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressBar(
                progress: plane.progress1,
                icon: Icons.support,
                text: "Easy",
                backgroundColor: Colors.white,
                size: 90.0,
              ),
              const SizedBox(width: 16),
              CircularProgressBar(
                progress: plane.progress2,
                icon: Icons.airplane_ticket,
                text: "Expertise",
                backgroundColor: Colors.white,
                size: 90.0,
              ),
              const SizedBox(width: 16),
              CircularProgressBar(
                progress: plane.progress3,
                icon: Icons.timer,
                text: "Range",
                backgroundColor: Colors.white,
                size: 90.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
