import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceDarker = Color(0xFF2C2C2C);
  static const Color surfaceLight = Color(0xFFF5F5F5); // Light surface color
  static const Color primary = Colors.blue;
  static const Color accent = Colors.blueAccent;

  // Superficies consolidadas
  static const Color cardColor = surfaceDark; // Tarjetas (sustituye a grey[850])
  static const Color buttonColor = surfaceDarker; // Botones (sustituye a Colors.black)

  // Texto
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textTertiary = Colors.white54;
  static const Color textMuted = Colors.white38;

  // Colores de estado
  static const Color success = Colors.green;
  static const Color warning = Colors.orange;
  static const Color error = Colors.red;
  static const Color info = Colors.blue;

  // Variantes semitransparentes (tokens)
  static final Color primarySoft = primary.withValues(alpha: 0.2);
  static final Color successSoft = success.withValues(alpha: 0.3);
  static final Color warningSoft = warning.withValues(alpha: 0.3);
  static final Color errorSoft = error.withValues(alpha: 0.3);
  static final Color successLight = success.withValues(alpha: 0.7);
  static final Color warningLight = warning.withValues(alpha: 0.7);
  static final Color errorLight = error.withValues(alpha: 0.7);
  static final Color whiteSoft = Colors.white.withValues(alpha: 0.6);

  // Colores para series de datos/charts
  static const Color chartPitch = Colors.red;
  static const Color chartRoll = Colors.deepPurple;
  static const Color chartYaw = Colors.lightBlue;
  static const Color chartAccelX = Colors.red;
  static const Color chartAccelY = Colors.green;
  static const Color chartAccelZ = Colors.blue;
  static const Color chartGyroX = Colors.pinkAccent;
  static const Color chartGyroY = Colors.tealAccent;
  static const Color chartGyroZ = Colors.amberAccent;
  static const Color chartMotor1 = Colors.orange;
  static const Color chartMotor2 = Colors.deepOrange;
  static const Color chartReq = Colors.green;
  static const Color chartCur = Colors.yellow;

  // Colores de secciones/tabs
  static final Color hangarColor = Colors.purple.shade800;
  static const Color cockpitColor = Colors.blue;
  static final Color recorderColor = Colors.red.shade900;
  static final Color mechanicsColor = Colors.teal.shade700;
  static final Color settingsColor = Colors.green.shade700;

  // Colores de instrumentos de vuelo
  static const Color instrumentFace = Color(0xFF0C0C10); // Cara del dial
  static const Color instrumentMark = Color(0xFFD9D9DE); // Marcas/agujas
  static const Color instrumentBezel = Color(0xFF3A3A40); // Bisel
  static const Color sky = Color(0xFF2E4E8C); // Cielo (ADI)
  static const Color skyHorizon = Color(0xFF7FA6D9); // Cielo cerca del horizonte
  static const Color ground = Color(0xFF6B4A2F); // Tierra (ADI)
  static const Color groundHorizon = Color(0xFFA97E55); // Tierra cerca del horizonte

  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.white70,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.white60,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Títulos de slider / campos de configuración
  static const TextStyle labelMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Valores numéricos de stats
  static const TextStyle statValue = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Labels de stats
  static const TextStyle statLabel = TextStyle(
    fontSize: 12,
    color: Colors.white70,
  );

  // Labels de métricas (filas label+valor)
  static const TextStyle metricLabel = TextStyle(
    fontSize: 13,
    color: Colors.white70,
  );

  // Ejes de charts
  static const TextStyle chartAxis = TextStyle(
    fontSize: 10,
    color: Colors.white70,
  );

  // Mensajes de estado (calibración, OTA)
  static const TextStyle statusMessage = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  static const TextStyle statusSuccess = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.green,
  );

  static const TextStyle statusError = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.red,
  );

  // Contador grande (calibración)
  static const TextStyle countdown = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primary,
    scaffoldBackgroundColor: backgroundDark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
      surface: surfaceDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: heading2,
    ),
    cardTheme: CardThemeData(
      color: surfaceDark,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primary,
      inactiveTrackColor: primary.withValues(alpha: 0.3),
      thumbColor: primary,
      overlayColor: primary.withValues(alpha: 0.1),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceDarker,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: heading1,
      displayMedium: heading2,
      displaySmall: heading3,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
    ),
  );
}

// Espaciados consolidados
class AppSpacing {
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 12;
  static const double spacingLg = 16;
  static const double spacingXl = 20;

  static const EdgeInsets pagePadding = EdgeInsets.all(spacingLg);
  static const EdgeInsets cardPadding = EdgeInsets.all(spacingLg);
  static const EdgeInsets listPadding = EdgeInsets.all(spacingSm);
}

// Radios consolidados
class AppRadius {
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusPill = 20;
}
