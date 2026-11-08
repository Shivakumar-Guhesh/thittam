import 'package:flutter/material.dart';

class AppColors {
  // --- Brand & Primary Colors (Electric Violet / Indigo) ---
  static const Color primary = Color(0xFF6366F1); // Vivid Indigo / Violet
  static const Color onPrimary = Colors.white;

  // --- Secondary Accent (Vibrant Cyan / Teal) ---
  static const Color secondary = Color(0xFF06B6D4); // Cyan
  static const Color onSecondary = Color(0xFF09090B);

  // --- Accent Spectrum (For Tags, Priorities, & Statuses) ---
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentPink = Color(0xFFEC4899);
  static const Color accentOrange = Color(0xFFF97316);
  static const Color accentEmerald = Color(0xFF10B981);
  static const Color accentBlue = Color(0xFF3B82F6);

  // --- Background & Surface (Dark Theme - Deep Slate & Rich Charcoal) ---
  static const Color darkBg = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkBorder = Color(0xFF334155); // Slate 700

  static const Color darkPrimaryContainer = Color(0xFF4F46E5);
  static const Color onDarkErrorContainer = Color(0xFF7F1D1D);

  // --- Background & Surface (Light Theme - Crisp & Clean) ---
  static const Color lightBg = Color(0xFFF8FAFC); // Slate 50
  static const Color lightSurface = Colors.white;
  static const Color lightBorder = Color(0xFFE2E8F0); // Slate 200

  static const Color lightPrimaryContainer = Color(0xFFEEF2FF);
  static const Color onLightErrorContainer = Color(0xFF991B1B);

  // --- Semantic: Error ---
  static const Color lightError = Color(0xFFEF4444); // Red 500
  static const Color lightErrorContainer = Color(0xFFFEF2F2);
  static const Color darkError = Color(0xFFF87171);
  static const Color darkErrorContainer = Color(0xFF450A0A);
  static const Color onErrorLight = Colors.white;
  static const Color onErrorDark = Color(0xFF450A0A);

  // --- Semantic: Success ---
  static const Color lightSuccess = Color(0xFF10B981); // Emerald 500
  static const Color lightSuccessContainer = Color(0xFFECFDF5);
  static const Color darkSuccess = Color(0xFF34D399);
  static const Color darkSuccessContainer = Color(0xFF064E3B);

  // --- UI Elements & Splash ---
  static const Color splashLight = Color(0x0D000000);
  static const Color splashDark = Color(0x1FFFFFFF);

  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF94A3B8); // Slate 400
}
