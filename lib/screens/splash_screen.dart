
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math';
import 'user_list_screen.dart';
import '../constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _driftController;
  late AnimationController _buttonController;
  late AnimationController _contentController;

  @override
  void initState() {
    super.initState();

    // Wave animation with continuous movement
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Floating panel animation
    _driftController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    // Button entrance animation
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Content entrance animation
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Sequence animations
    _contentController.forward();
    Future.delayed(const Duration(milliseconds: 2200), () {
      _buttonController.forward();
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _driftController.dispose();
    _buttonController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final drift = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _driftController, curve: Curves.easeInOutSine),
    );

    final rotate = Tween<double>(begin: -0.015, end: 0.015).animate(
      CurvedAnimation(parent: _driftController, curve: Curves.easeInOut),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Enhanced animated waves
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (_, __) {
                return CustomPaint(
                  painter: _BezierWavePainter(
                    progress: _waveController.value,
                    colors: [
                      [AppColors.primary.withOpacity(0.4), AppColors.primary.withOpacity(0.1)],
                      [AppColors.primary.withOpacity(0.25), AppColors.primary.withOpacity(0.06)],
                      [AppColors.accent.withOpacity(0.35), AppColors.accent.withOpacity(0.09)],
                    ],
                  ),
                );
              },
            ),
          ),

          // Frosted glass panel with enhanced effects
          Center(
            child: AnimatedBuilder(
              animation: drift,
              builder: (_, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..translate(0.0, drift.value)
                    ..rotateZ(rotate.value),
                  alignment: Alignment.center,
                  child: child,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    width: 320,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.18),
                          Colors.white.withOpacity(0.10),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Enhanced title animation
                        FadeTransition(
                          opacity: CurvedAnimation(
                            parent: _contentController,
                            curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
                          ),
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.3),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: _contentController,
                              curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
                            )),
                            child: Text(
                              'User Directory',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Enhanced subtitle animation
                        FadeTransition(
                          opacity: CurvedAnimation(
                            parent: _contentController,
                            curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
                          ),
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.3),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: _contentController,
                              curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
                            )),
                            child: Text(
                              'Discover and connect with users seamlessly',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.primary.withOpacity(0.85),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Enhanced button animation
                        FadeTransition(
                          opacity: _buttonController,
                          child: ScaleTransition(
                            scale: CurvedAnimation(
                              parent: _buttonController,
                              curve: Curves.fastOutSlowIn,
                            ),
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.5),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: _buttonController,
                                curve: Curves.fastOutSlowIn,
                              )),
                              child: ElevatedButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                    context, UserListScreen.routeName),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 56, vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 8,
                                  shadowColor: AppColors.primary.withOpacity(0.4),
                                ),
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Enhanced wave painter with more natural movement
class _BezierWavePainter extends CustomPainter {
  final double progress;
  final List<List<Color>> colors;

  _BezierWavePainter({
    required this.progress,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paints = <Paint>[];
    final offsets = [size.height * 0.68, size.height * 0.75, size.height * 0.82];
    final amplitudes = [22.0, 28.0, 32.0];
    final frequencies = [0.8, 1.0, 1.2];
    final speed = progress * 2 * pi;

    // Prepare gradient paints with improved performance
    for (var grad in colors) {
      paints.add(Paint()
        ..shader = LinearGradient(
          colors: grad,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill);
    }

    // Draw each layer with optimized path calculation
    for (int layer = 0; layer < paints.length; layer++) {
      final path = Path();
      final int segments = 16;
      final double segWidth = size.width / segments;

      // Calculate wave points with phase shift
      final wavePoints = List.generate(segments + 1, (i) {
        final x = segWidth * i;
        final waveHeight = amplitudes[layer] *
            sin(i / segments * 2 * pi * frequencies[layer] + speed + layer);
        return Offset(x, offsets[layer] + waveHeight);
      });

      path.moveTo(0, wavePoints.first.dy);

      // Create smooth cubic bezier curve through points
      for (int i = 1; i < wavePoints.length; i++) {
        final p0 = wavePoints[i - 1];
        final p1 = wavePoints[i];
        final controlX = (p0.dx + p1.dx) / 2;
        path.cubicTo(
          controlX, p0.dy,
          controlX, p1.dy,
          p1.dx, p1.dy,
        );
      }

      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();

      canvas.drawPath(path, paints[layer]);
    }
  }

  @override
  bool shouldRepaint(covariant _BezierWavePainter old) {
    return old.progress != progress;
  }
}