import 'package:flutter/material.dart';

import '../../../domain/entities/light_color.dart';

class TrafficLightCircle extends StatelessWidget {
  final LightColor color;
  final bool isActive;
  final Animation<double> animation;

  const TrafficLightCircle({
    super.key,
    required this.animation,
    required this.isActive,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 104,
      decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
      child: Center(
        child: FadeTransition(
          opacity: animation,
          child: Container(
            key: Key("light-${color.name}"),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: isActive ? _colors[color] : null,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

const Map<LightColor, Color> _colors = {
  LightColor.red: Colors.red,
  LightColor.yellow: Colors.yellow,
  LightColor.green: Colors.green,
};
