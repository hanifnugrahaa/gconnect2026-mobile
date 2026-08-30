import 'package:flutter/material.dart';

class AppConstants {
  // Base URLs
  // For Android Emulator use: http://10.0.2.2:8000
  // For Web / Windows / Device Preview use: http://localhost:8000
  static const String defaultBaseUrl = 'http://localhost:8000/api/v1';
  static const String defaultWsUrl = 'ws://localhost:8000/api/v1/telemetry/ws/dashboard';

  // App Strings
  static const String appName = 'G-Connect';
  static const String appTagline = 'Smart Farming & Environment Telemetry';
  
  // Storage Keys
  static const String keyToken = 'gconnect_auth_token';
  static const String keyUser = 'gconnect_user_data';
  static const String keyBaseUrl = 'gconnect_custom_base_url';
}

class AppColors {
  // Emerald Primary Palette
  static const Color primary = Color(0xFF059669);      // emerald-600
  static const Color primaryDark = Color(0xFF047857);  // emerald-700
  static const Color primaryLight = Color(0xFF10B981); // emerald-500
  static const Color primaryBg = Color(0xFFECFDF5);    // emerald-50
  
  // Neutral / Slate
  static const Color background = Color(0xFFF8FAFC);   // slate-50
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF0F172A);  // slate-900
  static const Color textSecondary = Color(0xFF64748B);// slate-500
  static const Color textMuted = Color(0xFF94A3B8);    // slate-400
  static const Color border = Color(0xFFE2E8F0);       // slate-200
  
  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // Agronomy Metric Colors
  static const Color nitrogen = Color(0xFF3B82F6);     // blue-500
  static const Color phosphorus = Color(0xFF8B5CF6);   // purple-500
  static const Color potassium = Color(0xFFEC4899);    // pink-500
  static const Color moisture = Color(0xFF06B6D4);     // cyan-500
  static const Color temperature = Color(0xFFF97316);  // orange-500
}
