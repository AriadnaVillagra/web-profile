// lib/core/widgets/wallpaper.dart
import 'dart:async';

import 'package:flutter/material.dart';

class Wallpaper extends StatefulWidget {
  final Widget child;
  final String text;
  final VoidCallback? onTap;

  final bool showCatAndBubble;
  final double groundHeightFactor;
  final double? catHeight;
  final double? bubbleWidth;
  final double? bubbleHeight;
  final EdgeInsetsGeometry contentPadding;

  const Wallpaper({
    super.key,
    required this.child,
    this.text = '',
    this.onTap,
    this.showCatAndBubble = true,
    this.groundHeightFactor = 0.28,
    this.catHeight,
    this.bubbleWidth,
    this.bubbleHeight = 90.0,
    this.contentPadding = const EdgeInsets.all(16.0),
  });

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  String _displayedText = '';
  Timer? _typewriterTimer;

  @override
  void initState() {
    super.initState();
    _startTypewriter(widget.text);
  }

  @override
  void didUpdateWidget(covariant Wallpaper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _startTypewriter(widget.text);
    }
  }

  @override
  void dispose() {
    _typewriterTimer?.cancel();
    super.dispose();
  }

  void _startTypewriter(String fullText) {
    _typewriterTimer?.cancel();
    setState(() {
      _displayedText = '';
    });

    if (fullText.isEmpty) return;

    int charIndex = 0;
    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 35), (
      timer,
    ) {
      if (charIndex < fullText.length) {
        if (mounted) {
          setState(() {
            _displayedText += fullText[charIndex];
          });
        }
        charIndex++;
      } else {
        timer.cancel();
      }
    });
  }

  void _handleTap() {
    if (_displayedText.length < widget.text.length) {
      _typewriterTimer?.cancel();
      setState(() {
        _displayedText = widget.text;
      });
    } else {
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF52A2),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final isMobile = width < 600;

          final groundHeight = height * widget.groundHeightFactor;

          final defaultCatHeight = isMobile
              ? (height * 0.22).clamp(130.0, 180.0)
              : (height * 0.28).clamp(170.0, 240.0);
          final finalCatHeight = widget.catHeight ?? defaultCatHeight;

          final defaultBubbleWidth = isMobile
              ? (width - 40).clamp(220.0, 360.0)
              : (width * 0.35).clamp(100.0, 250.0);
          final finalBubbleWidth = widget.bubbleWidth ?? defaultBubbleWidth;

          // Cálculo responsivo de posiciones
          final catBottom = groundHeight - (finalCatHeight * 0.20);
          final catRight = isMobile
              ? (width / 2) - (finalCatHeight / 2)
              : width * 0.08;

          final bubbleBottom = isMobile
              ? groundHeight + finalCatHeight * 0.80
              : groundHeight + (finalCatHeight * 0.55);

          final double? bubbleLeft = isMobile
              ? (width - finalBubbleWidth) / 2
              : null;

          final double? bubbleRight = isMobile
              ? null
              : catRight + (finalCatHeight * 0.90);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _handleTap,
            child: Stack(
              children: [
                // 1. Suelo Verde
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: groundHeight,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF7BE552),
                      border: Border(
                        top: BorderSide(color: Colors.black, width: 4),
                      ),
                    ),
                  ),
                ),

                // 2. Contenido de la Pantalla
                Positioned.fill(
                  bottom: groundHeight,
                  child: Padding(
                    padding: widget.contentPadding,
                    child: widget.child,
                  ),
                ),

                // 3. Gato
                if (widget.showCatAndBubble)
                  Positioned(
                    bottom: catBottom,
                    right: catRight,
                    child: Image.asset(
                      'assets/images/grumpy_cat.png',
                      height: finalCatHeight,
                      fit: BoxFit.contain,
                    ),
                  ),

                // 4. Viñeta Adaptativa
                if (widget.showCatAndBubble && widget.text.isNotEmpty)
                  Positioned(
                    bottom: bubbleBottom,
                    left: bubbleLeft,
                    right: bubbleRight,
                    child: SizedBox(
                      width: finalBubbleWidth,
                      height: widget.bubbleHeight,
                      child: CustomPaint(
                        painter: SpeechBubblePainter(isBottomTail: isMobile),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
                          alignment: Alignment.center,
                          child: SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            child: Text(
                              _displayedText,
                              style: TextStyle(
                                fontSize: isMobile ? 14 : 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Courier',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SpeechBubblePainter extends CustomPainter {
  final bool isBottomTail;

  SpeechBubblePainter({this.isBottomTail = false});

  @override
  void paint(Canvas canvas, Size size) {
    const double radius = 20.0;
    const double tailWidth = 18.0;
    const double tailHeight = 16.0;

    Path getBubblePath() {
      final path = Path();
      path.moveTo(radius, 0);
      path.lineTo(size.width - radius, 0);
      path.quadraticBezierTo(size.width, 0, size.width, radius);
      path.lineTo(size.width, size.height - radius);
      path.quadraticBezierTo(
        size.width,
        size.height,
        size.width - radius,
        size.height,
      );

      if (isBottomTail) {
        path.lineTo((size.width / 2) + (tailWidth / 2), size.height);
        path.lineTo(size.width / 2, size.height + tailHeight);
        path.lineTo((size.width / 2) - (tailWidth / 2), size.height);
      } else {
        path.lineTo(size.width - 30, size.height);
        path.lineTo(size.width - 10, size.height + tailHeight);
        path.lineTo(size.width - 30 - tailWidth, size.height);
      }

      path.lineTo(radius, size.height);
      path.quadraticBezierTo(0, size.height, 0, size.height - radius);
      path.lineTo(0, radius);
      path.quadraticBezierTo(0, 0, radius, 0);
      path.close();

      return path;
    }

    final path = getBubblePath();

    final shadowPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawPath(path.shift(const Offset(4, 4)), shadowPaint);

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
