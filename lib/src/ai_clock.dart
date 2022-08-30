import 'dart:async';

import 'package:flutter/material.dart';

import 'painter/clock_painter.dart';

/// AiClock
class AiClock extends StatefulWidget {
  const AiClock({Key? key}) : super(key: key);

  @override
  State<AiClock> createState() => _AiClockState();
}

class _AiClockState extends State<AiClock> {
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int second = DateTime.now().second;
    return CustomPaint(
      painter: ClockPainter(
        interval: 5,
        lineCount: 60,
        color: Colors.green,
        maxCount: 60,
        currentCount: second,
      ),
    );
    // return ArcProgressBar();
  }
}
