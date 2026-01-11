import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales
  static const Color primaryColor = Color(0xFF014040);
  static const Color primaryLight = Color(0xFF73B8BF);
  static const Color primaryDark = Color(0xFF012626);

  // Colores secundarios
  static const Color secondaryColor = Color(0xFFFF6B6B); // Red
  static const Color secondaryLight = Color(0xFFD98B99);
  static const Color secondaryDark = Color(0xFFE03939);

  // Colores neutros
  static const Color backgroundColor = Color(0xFFF2F2F2);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFD90404);

  // Colores de texto
  static const Color textPrimary = Color.fromARGB(255, 33, 33, 33);
  static const Color textSecondary = Color.fromARGB(255, 117, 117, 117);
  static const Color textHint = Color.fromARGB(255, 189, 189, 189);
  static const Color textInverse = Color.fromARGB(255, 255, 255, 255);

  // Bordes
  static const Color borderColor = Color.fromARGB(255, 224, 224, 224);
  static const double borderRadius = 8.0;
  static const double borderRadiusLarge = 16.0;

  // Espaciado
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // Tamaños de fuente
  static const double fontSizeSmall = 12.0;
  static const double fontSizeBase = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeXLarge = 20.0;
  static const double fontSizeTitle = 24.0;
  static const double fontSizeHeading = 32.0;

  // Tema Light
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: textInverse,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: _appBarTextStyle(),
      ),
      // TextField / Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMedium,
          vertical: spacingMedium,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: errorColor),
        ),
        hintStyle: _hintTextStyle(),
        labelStyle: _labelTextStyle(),
      ),
      // Botones
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textInverse,
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLarge,
            vertical: spacingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          textStyle: _buttonTextStyle(),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: _buttonTextStyle(),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingMedium,
            vertical: spacingSmall,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLarge,
            vertical: spacingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          textStyle: _buttonTextStyle(),
        ),
      ),
      // Card
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      // Tipografía
      textTheme: _buildTextTheme(),
    );
  }

  // Tema Dark (opcional)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 33, 33, 33),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryDark,
        foregroundColor: textInverse,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: _appBarTextStyle(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color.fromARGB(255, 48, 48, 48),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMedium,
          vertical: spacingMedium,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Color.fromARGB(255, 97, 97, 97)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Color.fromARGB(255, 97, 97, 97)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        hintStyle: _hintTextStyle(),
        labelStyle: _labelTextStyle(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textInverse,
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLarge,
            vertical: spacingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          textStyle: _buttonTextStyle(),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color.fromARGB(255, 48, 48, 48),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      textTheme: _buildTextTheme(),
    );
  }

  // Estilos de texto reutilizables
  static TextStyle _appBarTextStyle() {
    return const TextStyle(
      fontSize: fontSizeTitle,
      fontWeight: FontWeight.bold,
      color: textInverse,
    );
  }

  static TextStyle _buttonTextStyle() {
    return const TextStyle(
      fontSize: fontSizeMedium,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    );
  }

  static TextStyle _hintTextStyle() {
    return const TextStyle(
      fontSize: fontSizeBase,
      color: textHint,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle _labelTextStyle() {
    return const TextStyle(
      fontSize: fontSizeMedium,
      color: textSecondary,
      fontWeight: FontWeight.w500,
    );
  }

  static TextTheme _buildTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontSize: fontSizeHeading,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      displaySmall: TextStyle(
        fontSize: fontSizeTitle,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      headlineSmall: TextStyle(
        fontSize: fontSizeXLarge,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: fontSizeLarge,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: fontSizeMedium,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      titleSmall: TextStyle(
        fontSize: fontSizeBase,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: fontSizeMedium,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: fontSizeBase,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: fontSizeSmall,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        fontSize: fontSizeBase,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      labelSmall: TextStyle(
        fontSize: fontSizeSmall,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
    );
  }
}
