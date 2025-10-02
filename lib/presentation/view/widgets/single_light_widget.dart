import 'package:flutter/material.dart';
import 'package:ukrposhtatest/domain/entities/traffic_light.dart';

class TrafficLightCircle extends StatelessWidget {
  final LightColor color;
  final bool isActive;
  final Animation<double> animation;

  const TrafficLightCircle({
    required this.animation,
    required this.isActive,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
      child: FadeTransition(
        opacity: animation,
        child: Container(
          key: Key("light-${color.name}"),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: isActive ? lightWidgetColors[color] : null,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

const Map<LightColor, Color> lightWidgetColors = {
  LightColor.red: Colors.red,
  LightColor.yellow: Colors.yellow,
  LightColor.green: Colors.green,
};
