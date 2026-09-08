import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperwings/bloc/calibration_bloc/calibration_bloc.dart';
import 'package:paperwings/clients/mock_plane_client.dart';
import 'package:paperwings/config/app_theme.dart';
import 'package:paperwings/widgets/calibration_specs.dart';
import 'package:paperwings/widgets/calibration_view.dart';
import 'package:paperwings/widgets/full_width_button.dart';

void main() {
  testWidgets('Iniciar Calibración button is pinned at the bottom',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 600,
            child: BlocProvider(
              create: (_) => CalibrationBloc(MockPlaneClient()),
              child: CalibrationView(spec: imuCalibrationSpec()),
            ),
          ),
        ),
      ),
    );

    final button = find.widgetWithText(FullWidthButton, 'Iniciar Calibración');
    expect(button, findsOneWidget);
    final rect = tester.getRect(button);
    // El botón está envuelto en AppSpacing.pagePadding (16), así que su borde
    // inferior debe quedar a 600 - 16.
    expect(rect.bottom, closeTo(600 - AppSpacing.pagePadding.bottom, 1));
  });
}