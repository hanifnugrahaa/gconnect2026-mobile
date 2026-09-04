import 'dart:ui';
import 'package:flutter/material.dart';

/// Reusable Master Liquid Glass Panel widget with frosted blur,
/// specular rim highlight, and glossy top reflection sheen.
class LiquidGlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blur;
  final VoidCallback? onTap;
  final List<Color>? gradientColors;
  final Color? borderColor;
  final double borderWidth;
  final bool hasTopSheen;
  final List<BoxShadow>? customShadows;
  final double? width;
  final double? height;

  const LiquidGlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.borderRadius = 22.0,
    this.blur = 24.0,
    this.onTap,
    this.gradientColors,
    this.borderColor,
    this.borderWidth = 1.0,
    this.hasTopSheen = true,
    this.customShadows,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ??
        [
          const Color(0xFF0D281D).withOpacity(0.70), // Dark emerald glass
          const Color(0xFF061A12).withOpacity(0.85), // Deep forest tint
        ];

    final bColor = borderColor ?? Colors.white.withOpacity(0.16);

    Widget panel = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: customShadows ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 24,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: const Color(0xFF059669).withOpacity(0.12),
                blurRadius: 16,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Stack(
            children: [
              // Base Tint & Specular Rim Border
              Container(
                padding: padding,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: colors,
                  ),
                  border: Border.all(
                    color: bColor,
                    width: borderWidth,
                  ),
                ),
                child: child,
              ),

              // Glossy Top Reflection Sheen
              if (hasTopSheen)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 32,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(borderRadius),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.20),
                          Colors.white.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: panel,
      );
    }

    return panel;
  }
}
