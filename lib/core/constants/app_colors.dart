import 'package:flutter/material.dart';

/// App color constants
/// Centralized color definitions for consistent theming across the app
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors
  static const Color primary = Color(0xFF00BE6C);
  static const Color primaryDark = Color(0xFF009955);

  // Background Colors
  static final Color background = Colors.grey[100]!;
  static const Color surface = Colors.white;
  static final Color surfaceVariant = Colors.grey[300]!;

  // Text Colors
  static const Color textPrimary = Colors.black;
  static final Color textSecondary = Colors.grey[800]!;
  static final Color textTertiary = Colors.grey[600]!;
  static const Color textOnPrimary = Colors.white;

  // Icon Colors
  static const Color iconActive = Colors.black;
  static const Color iconInactive = Colors.grey;

  // State Colors
  static const Color success = Color(0xFF00BE6C);
  static const Color running = Colors.blue;
  static final Color error = Colors.red[700]!;
  static final Color errorLight = Colors.red[50]!;
  static final Color errorBorder = Colors.red[300]!;

  // GPS State Colors
  static const Color gpsActive = Colors.blue;
  static const Color gpsStopped = Color(0xFF00BE6C);
  static final Color gpsDisabled = Colors.grey[500]!;
  static const Color gpsStop = Color(0xFFE53935);

  // Shadow Colors
  static const Color shadow = Colors.black12;
  static const Color shadowDark = Colors.black26;
}
