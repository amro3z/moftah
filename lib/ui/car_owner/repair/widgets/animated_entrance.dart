import 'package:flutter/material.dart';

class AnimatedEntrance extends StatelessWidget {
  final Widget child;
  final Duration delay;
  final Offset beginOffset;

  const AnimatedEntrance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.beginOffset = const Offset(0, 18),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 420 + delay.inMilliseconds),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final delayedValue = delay.inMilliseconds == 0
            ? value
            : ((value * (420 + delay.inMilliseconds) - delay.inMilliseconds) /
                    420)
                .clamp(0.0, 1.0).toDouble();
        return Opacity(
          opacity: delayedValue,
          child: Transform.translate(
            offset: Offset(
              beginOffset.dx * (1 - delayedValue),
              beginOffset.dy * (1 - delayedValue),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
