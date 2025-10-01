import '../../domain/entities/light_color.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'traffic_light_state.freezed.dart';

@freezed
abstract class TrafficLightState with _$TrafficLightState {
  const TrafficLightState._();

  const factory TrafficLightState.stopped() = StoppedTrafficLightState;

  const factory TrafficLightState.regular(LightColor currentColor) =
      RegularTrafficLightState;

  const factory TrafficLightState.blinkingYellow() =
      BlinkingYellowTrafficLightState;

  const factory TrafficLightState.blinkingGreen() =
      BlinkingGreenTrafficLightState;

  LightColor? get currentColor => when(
    stopped: () => null,
    regular: (currentColor) => currentColor,
    blinkingGreen: () => LightColor.green,
    blinkingYellow: () => LightColor.yellow,
  );

  bool get isOn => this is! StoppedTrafficLightState;

  bool get isBlinking =>
      whenOrNull(blinkingYellow: () => true, blinkingGreen: () => true) ??
      false;

  bool get isRegular =>
      this is RegularTrafficLightState ||
      this is BlinkingGreenTrafficLightState;
}
