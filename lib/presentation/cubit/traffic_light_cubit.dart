import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukrposhtatest/domain/entities/light_color.dart';
import 'package:ukrposhtatest/domain/get_duration_use_case.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_state.dart';

import '../../common.dart';

class TrafficLightCubit extends Cubit<TrafficLightState> {
  TrafficLightCubit() : super(const TrafficLightState());

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

  bool get isStopped => state.mode == TrafficLightMode.stopped;


  void runRegular() async {
    if (state.mode == TrafficLightMode.regular) return;

    final needRestart = isStopped;

    emit(TrafficLightState.regular());

    if (needRestart) {
      _nextColor();
    }
  }

  void stop() async {
    if (state.mode == TrafficLightMode.stopped) return;
    emit(TrafficLightState.stopped());
  }

  void runBlinkingYellow() {
    if (state.mode == TrafficLightMode.blinkingYellow) return;

    final needRestart = isStopped;

    emit(TrafficLightState.blinkingYellow());

    if (needRestart) {
      _nextColor();
    }
  }

  void _nextColor() async {
    if (isStopped) return;

    _currColorIndex = (_currColorIndex + 1) % 4;
    final nextColor = _colorsCycle[_currColorIndex];
    // if (nextColor == LightColor.green) {
    //   _scheduleBlinking(
    //     Duration(seconds: _lightsDurations[LightColor.green]! - 1),
    //   );
    // }

    emit(state.copyWith(currentColor: nextColor));

    Future.delayed(
      _lightsDurations[nextColor]!,
    ).then((_) => _nextColor());
  }

  void _scheduleBlinking(Duration delay) async {
    await Future.delayed(delay);
    // emit(state.copyWith(isBlinking: true));
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
