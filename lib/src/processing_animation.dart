import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

// Le resto 1.0 porque se ve una linea entre los ticks :(
const double _size = 7.0;
const int _ticks = 12;
const Duration _duration = Duration(milliseconds: 3500);

class ProcessingAnimation extends StatefulWidget {
  const ProcessingAnimation({super.key});

  @override
  State<ProcessingAnimation> createState() => _ProcessingAnimationState();
}

class _ProcessingAnimationState extends State<ProcessingAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late bool _completed;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _duration);
    _completed = false;
    _repeat();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _repeat() async {
    await _controller.forward(from: 0.0);
    _completed = !_completed;
    _repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => CustomPaint(
        painter: _TicksPainter(
          value: _controller.value,
          completed: _completed,
        ),
      ),
    );
  }
}

class _TicksPainter extends CustomPainter {
  const _TicksPainter({required double value, required this.completed}) : tick = _ticks * value;

  final double tick;
  final bool completed;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width * 0.5, size.height * 0.5);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _size + 1.0
      ..color = Colors.grey[200]!;
    const angle = (pi * 2.0) / _ticks;

    canvas.drawPoints(
      PointMode.lines,
      [
        for (var i = 1; i < _ticks + 1; i++)
          ...() {
            final radiansPercent = tick / _ticks;
            final totalRadians = pi * 2.0 * radiansPercent;
            double radians = angle * (i - 1);

            final radiusPercent = (i - tick).clamp(0.0, 1.0);
            double outerRadius = _size * _ticks;

            if (!completed) {
              radians = max(radians, totalRadians);
              outerRadius = lerpDouble(_size * i, outerRadius, radiusPercent)!;
            } else {
              radians = min(radians, totalRadians);
              outerRadius = lerpDouble(outerRadius, _size * (_ticks - i + 1), radiusPercent)!;
            }

            radians = radians - pi * 0.5;
            final innerRadius = outerRadius - _size - 1.0;

            return [
              Offset(outerRadius * cos(radians), outerRadius * sin(radians)),
              Offset(innerRadius * cos(radians), innerRadius * sin(radians)),
            ];
          }(),
      ],
      paint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_TicksPainter oldDelegate) => oldDelegate.tick != tick || oldDelegate.completed != completed;
}
