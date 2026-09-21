import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Visual language: a night chapel. Deep ink surfaces, gilded accents and
/// parchment text, with roman capitals for names and a humanist sans for
/// reading.
abstract final class Palette {
  static const ink = Color(0xFF0C0B16);
  static const inkRaised = Color(0xFF171429);
  static const inkLine = Color(0xFF2A2542);
  static const gold = Color(0xFFD9B25F);
  static const goldLight = Color(0xFFF1D89A);
  static const goldDark = Color(0xFF8C6A24);
  static const parchment = Color(0xFFF2E7CF);
  static const parchmentDim = Color(0xFFB9AE95);
  static const crimson = Color(0xFFA93A3A);
  static const crimsonLight = Color(0xFFD86A62);

  static const goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldLight, gold, goldDark, gold, goldLight],
    stops: [0, 0.3, 0.55, 0.8, 1],
  );
}

ThemeData buildTheme() {
  final base = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: Palette.gold,
      onPrimary: Palette.ink,
      primaryContainer: Palette.goldDark,
      onPrimaryContainer: Palette.parchment,
      secondary: Palette.crimson,
      onSecondary: Palette.parchment,
      secondaryContainer: Color(0xFF4A1E1E),
      onSecondaryContainer: Palette.parchment,
      surface: Palette.ink,
      onSurface: Palette.parchment,
      surfaceContainerHighest: Palette.inkRaised,
      onSurfaceVariant: Palette.parchmentDim,
      outline: Palette.inkLine,
      error: Palette.crimsonLight,
      onError: Palette.ink,
      errorContainer: Color(0xFF4A1E1E),
      onErrorContainer: Palette.parchment,
    ),
    scaffoldBackgroundColor: Palette.ink,
  );

  final body = GoogleFonts.nunitoSansTextTheme(base.textTheme).apply(
    bodyColor: Palette.parchment,
    displayColor: Palette.parchment,
  );
  final display = GoogleFonts.cinzelTextTheme(base.textTheme);

  final textTheme = body.copyWith(
    displayLarge: display.displayLarge?.copyWith(
      color: Palette.gold,
      fontWeight: FontWeight.w700,
    ),
    displayMedium: display.displayMedium?.copyWith(
      color: Palette.gold,
      fontWeight: FontWeight.w700,
    ),
    displaySmall: display.displaySmall?.copyWith(
      color: Palette.parchment,
      fontWeight: FontWeight.w700,
    ),
    headlineLarge: display.headlineLarge?.copyWith(
      color: Palette.parchment,
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: display.headlineMedium?.copyWith(
      color: Palette.parchment,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: display.headlineSmall?.copyWith(
      color: Palette.parchment,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: display.titleLarge?.copyWith(
      color: Palette.parchment,
      fontWeight: FontWeight.w600,
      letterSpacing: 1,
    ),
    labelLarge: body.labelLarge?.copyWith(
      letterSpacing: 1.6,
      fontWeight: FontWeight.w800,
    ),
    labelSmall: body.labelSmall?.copyWith(
      letterSpacing: 2,
      fontWeight: FontWeight.w800,
      color: Palette.parchmentDim,
    ),
  );

  return base.copyWith(
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Palette.parchment,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: Palette.gold,
        letterSpacing: 3,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Palette.inkRaised,
      indicatorColor: Palette.goldDark.withValues(alpha: 0.35),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? Palette.goldLight
              : Palette.parchmentDim,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => textTheme.labelSmall?.copyWith(
          letterSpacing: 1.2,
          color: states.contains(WidgetState.selected)
              ? Palette.goldLight
              : Palette.parchmentDim,
        ),
      ),
    ),
    cardTheme: const CardThemeData(
      color: Palette.inkRaised,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        side: BorderSide(color: Palette.inkLine),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Palette.inkRaised,
      labelStyle: const TextStyle(color: Palette.parchmentDim),
      hintStyle: const TextStyle(color: Palette.parchmentDim),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Palette.inkLine),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Palette.inkLine),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Palette.gold, width: 1.5),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Palette.gold,
        foregroundColor: Palette.ink,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: textTheme.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Palette.gold,
        side: const BorderSide(color: Palette.goldDark),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: textTheme.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Palette.goldLight),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Palette.inkRaised,
      side: const BorderSide(color: Palette.inkLine),
      labelStyle: textTheme.labelSmall?.copyWith(color: Palette.parchment),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    dividerTheme: const DividerThemeData(color: Palette.inkLine),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Palette.inkRaised,
      contentTextStyle: textTheme.bodyMedium,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Palette.goldDark),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: Palette.inkRaised,
      textStyle: textTheme.bodyMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Palette.inkLine),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Palette.inkRaised,
      titleTextStyle: textTheme.headlineSmall,
      contentTextStyle: textTheme.bodyMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Palette.inkLine),
      ),
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: Palette.gold,
      inactiveTrackColor: Palette.inkLine,
      thumbColor: Palette.goldLight,
      overlayColor: Color(0x33D9B25F),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? Palette.ink
            : Palette.parchmentDim,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) =>
            s.contains(WidgetState.selected) ? Palette.gold : Palette.inkRaised,
      ),
    ),
  );
}
