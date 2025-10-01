import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukrposhtatest/domain/entities/light_color.dart';
import 'package:ukrposhtatest/domain/get_duration_use_case.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_state.dart';

import '../../common.dart';

class TrafficLightCubit extends Cubit<TrafficLightState> {
  TrafficLightCubit() : super(const TrafficLightState.regular(LightColor.red));

  int _currColorIndex = 0;
  Map<LightColor, Duration> _lightsDurations = defaultLightsDurations;

  static const Map<LightColor, Duration> defaultLightsDurations = {
    LightColor.yellow: Duration(seconds: 1),
    LightColor.red: Duration(seconds: 3),
    LightColor.green: Duration(seconds: 3),
  };

  static const _colorsCycle = [
    LightColor.red,
    LightColor.yellow,
    LightColor.green,
    LightColor.yellow,
  ];

  static const _greenBlinkDurationMs = 500;

  bool get isStopped => state is StoppedTrafficLightState;

  void start() => runRegular();

  void runRegular() {
    if (state is RegularTrafficLightState) return;

    final needRestart = isStopped;

    emit(TrafficLightState.regular(LightColor.red));

    if (needRestart) {
      _nextColor();
    }
  }

  void stop() {
    if (state is StoppedTrafficLightState) return;
    emit(TrafficLightState.stopped());
  }

  void runBlinkingYellow() {
    if (state is BlinkingYellowTrafficLightState) return;

    final needRestart = isStopped;

    emit(TrafficLightState.blinkingYellow());

    if (needRestart) {
      _nextColor();
    }
  }

  void _nextColor() {
    if (isStopped) return;

    _currColorIndex = (_currColorIndex + 1) % 4;
    final nextColor = _colorsCycle[_currColorIndex];

    if (nextColor == LightColor.green) {
      final greenDuration = _lightsDurations[LightColor.green]!;
      _scheduleBlinking(
        Duration(
          milliseconds: greenDuration.inMilliseconds - _greenBlinkDurationMs,
        ),
      );
    }

    emit(TrafficLightState.regular(nextColor));

    Future.delayed(_lightsDurations[nextColor]!).then((_) => _nextColor());
  }

  void _scheduleBlinking(Duration delay) async {
    await Future.delayed(delay);
    emit(TrafficLightState.regular(LightColor.green, isGreenBlinking: true));
  }

  Future<void> fetchLightsDurations() async {
    final useCase = getIt<GetLightDurationUseCase>();

    final Map<LightColor, Duration> durations = {};

    await Future.wait(
      LightColor.values.map((color) async {
        final value = await useCase.getLightDuration(color);
        durations.putIfAbsent(color, () => value);
      }),
    );

    _lightsDurations = durations;
  }
}
