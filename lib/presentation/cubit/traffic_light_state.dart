import '../../domain/entities/light_color.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'traffic_light_state.freezed.dart';

@freezed
abstract class TrafficLightState with _$TrafficLightState {
  const TrafficLightState._();

  const factory TrafficLightState({
    @Default(null) LightColor? currentColor,
    @Default(TrafficLightMode.regular) TrafficLightMode mode,
  }) = _TrafficLightState;

  factory TrafficLightState.stopped() =>
      TrafficLightState(currentColor: null, mode: TrafficLightMode.stopped);

  factory TrafficLightState.regular() => TrafficLightState(
    currentColor: LightColor.red,
    mode: TrafficLightMode.regular,
  );

  factory TrafficLightState.blinkingYellow() => TrafficLightState(
    currentColor: LightColor.yellow,
    mode: TrafficLightMode.blinkingYellow,
  );

  bool get isOn => mode != TrafficLightMode.stopped;
}
