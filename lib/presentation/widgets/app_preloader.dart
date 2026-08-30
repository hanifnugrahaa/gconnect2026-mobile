import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants.dart';

class AppPreloader extends StatefulWidget {
  final String? message;
  final bool fullScreen;

  const AppPreloader({
    super.key,
    this.message,
    this.fullScreen = true,
  });

  @override
  State<AppPreloader> createState() => _AppPreloaderState();
}

class _AppPreloaderState extends State<AppPreloader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<Map<String, dynamic>> _logos = [
    {'path': 'assets/images/Logo-UGM.png', 'height': 38.0, 'delay': 0.0},
    {'path': 'assets/images/Logo-DIKE.png', 'height': 30.0, 'delay': 0.18},
    {'path': 'assets/images/logo-icon.webp', 'height': 32.0, 'delay': 0.36},
    {'path': 'assets/images/logo-webdev.webp', 'height': 32.0, 'delay': 0.54},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Title: COMMUNITY SERVICE PROGRAM
              const Text(
                'COMMUNITY SERVICE PROGRAM',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Row of Staggered Bouncing Wavy Logos
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _logos.map((logo) {
                  final delay = logo['delay'] as double;
                  // Sine wave offset calculation based on progress + delay
                  final progress = (_controller.value + delay) % 1.0;
                  final waveOffset = math.sin(progress * 2 * math.pi) * 8.0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Transform.translate(
                      offset: Offset(0, waveOffset),
                      child: Image.asset(
                        logo['path'] as String,
                        height: logo['height'] as double,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.image,
                          size: 28,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Sequential Looping Three Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.message ?? 'Mohon tunggu',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  _buildAnimatedDot(0.0),
                  _buildAnimatedDot(0.25),
                  _buildAnimatedDot(0.5),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (!widget.fullScreen) return content;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: content),
    );
  }

  Widget _buildAnimatedDot(double delay) {
    final progress = (_controller.value + delay) % 1.0;
    // Fade in between 0.0 to 0.4, stay visible to 0.7, fade out by 1.0
    double opacity = 0.2;
    if (progress >= 0.0 && progress <= 0.3) {
      opacity = 0.2 + (progress / 0.3) * 0.8;
    } else if (progress > 0.3 && progress <= 0.7) {
      opacity = 1.0;
    } else {
      opacity = 1.0 - ((progress - 0.7) / 0.3) * 0.8;
    }

    return Opacity(
      opacity: opacity.clamp(0.2, 1.0),
      child: const Text(
        '.',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
