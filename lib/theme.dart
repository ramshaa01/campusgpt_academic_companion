import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CampusGptTheme {
  // Colors
  static const Color surface = Color(0xFF0B1326);
  static const Color surfaceDim = Color(0xFF0B1326);
  static const Color surfaceBright = Color(0xFF31394D);
  static const Color surfaceContainerLowest = Color(0xFF060E20);
  static const Color surfaceContainerLow = Color(0xFF131B2E);
  static const Color surfaceContainer = Color(0xFF171F33);
  static const Color surfaceContainerHigh = Color(0xFF222A3D);
  static const Color surfaceContainerHighest = Color(0xFF2D3449);
  
  static const Color onSurface = Color(0xFFDAE2FD);
  static const Color onSurfaceVariant = Color(0xFFC7C4D7);
  
  static const Color primary = Color(0xFFC0C1FF);
  static const Color onPrimary = Color(0xFF1000A9);
  static const Color primaryContainer = Color(0xFF8083FF);
  
  static const Color secondary = Color(0xFF5DE6FF);
  static const Color onSecondary = Color(0xFF00363E);
  static const Color secondaryContainer = Color(0xFF00CBE6);
  
  static const Color tertiary = Color(0xFFDDB7FF);
  static const Color onTertiary = Color(0xFF490080);
  
  static const Color error = Color(0xFFFFB4AB);
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        surface: surface,
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        primaryContainer: primaryContainer,
        secondaryContainer: secondaryContainer,
        error: error,
      ),
      scaffoldBackgroundColor: surfaceContainerLowest,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainer,
        labelStyle: const TextStyle(color: onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: onSurface.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: onSurface.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryContainer,
          foregroundColor: onSurface,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.notoSans(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02,
          height: 1.1,
          color: onSurface,
        ),
        displayMedium: GoogleFonts.notoSans(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 1.2,
          color: onSurface,
        ),
        headlineMedium: GoogleFonts.notoSans(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: onSurface,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          height: 1.6,
          color: onSurfaceVariant,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: onSurfaceVariant,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: onSurfaceVariant,
        ),
        labelSmall: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.0,
          letterSpacing: 0.05,
          color: onSurfaceVariant,
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const GlassCard({
    Key? key,
    required this.child,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16.0),
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      decoration: BoxDecoration(
        color: CampusGptTheme.surfaceContainer.withOpacity(0.6),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }
    return card;
  }
}

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient gradient;

  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
