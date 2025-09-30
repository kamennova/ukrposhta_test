import '../../domain/entities/light_color.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'traffic_light_state.freezed.dart';

@freezed
abstract class TrafficLightState with _$TrafficLightState {
  const factory TrafficLightState({
    @Default(LightColor.red) LightColor currentColor,
    @Default(false) bool isPaused,
    @Default(false) bool isBlinking,
  }) = _TrafficLightState;

  factory TrafficLightState.initial() {
    return const TrafficLightState();
  }
}
