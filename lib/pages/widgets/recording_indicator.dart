import 'package:flutter/material.dart';
import 'package:paperwings/config/app_theme.dart';

class RecordingIndicator extends StatelessWidget {
  final int duration;
  final bool isRecording;

  const RecordingIndicator({
    super.key,
    required this.isRecording,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Círculo que indica si está grabando
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isRecording ? Colors.red : Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              Duration(seconds: duration).toString().substring(2, 7),
              style: AppTheme.heading3,
            ),
          ],
        ),
      ),
    );
  }
}
