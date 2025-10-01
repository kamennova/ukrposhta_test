import '../../domain/entities/light_color.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'traffic_light_state.freezed.dart';

@freezed
abstract class TrafficLightState with _$TrafficLightState {
  const TrafficLightState._();

  factory TrafficLightState.stopped() = StoppedTrafficLightState;

  const factory TrafficLightState.regular(
    LightColor currentColor, {
    @Default(false) bool isGreenBlinking,
  }) = RegularTrafficLightState;

  factory TrafficLightState.blinkingYellow() = BlinkingYellowTrafficLightState;

  LightColor? get currentColor => when(
    stopped: () => null,
    regular: (currentColor, isGreenBlinking) => currentColor,
    blinkingYellow: () => LightColor.yellow,
  );

  bool get isOn => this is! StoppedTrafficLightState;

  bool get isBlinking => whenOrNull(blinkingYellow: () => true, regular: (currentColor, isGreenBlinking) => isGreenBlinking) ?? false;
}
