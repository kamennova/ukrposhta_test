import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ukrposhtatest/domain/entities/traffic_light.dart';

part 'traffic_light_state.freezed.dart';

@freezed
abstract class TrafficLightState with _$TrafficLightState {
  LightColor? get currentColor => when(
    stopped: () => null,
    regular: (currentColor) => currentColor,
    blinkingYellow: () => LightColor.yellow,
  );

  bool get isOn => this is! StoppedTrafficLightState;

  bool get isBlinking => this is BlinkingYellowTrafficLightState;

  const TrafficLightState._();

  const factory TrafficLightState.stopped() = StoppedTrafficLightState;

  const factory TrafficLightState.regular(LightColor currentColor) =
      RegularTrafficLightState;

  const factory TrafficLightState.blinkingYellow() =
      BlinkingYellowTrafficLightState;
}
