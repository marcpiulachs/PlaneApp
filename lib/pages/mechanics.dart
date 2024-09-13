import 'package:flutter/material.dart';

class Mechanics extends StatelessWidget {
  const Mechanics({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Text(
          "Mechanics Tab",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
