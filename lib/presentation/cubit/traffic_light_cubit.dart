import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukrposhtatest/domain/entities/light_color.dart';
import 'package:ukrposhtatest/domain/get_duration_use_case.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_state.dart';

import '../../common.dart';

class TrafficLightCubit extends Cubit<TrafficLightState> {
  TrafficLightCubit() : super(const TrafficLightState());

  int _currColorIndex = 0;
  Map<LightColor, int> _lightsDurations = defaultLightsDurations;

  static const Map<LightColor, int> defaultLightsDurations = {
    LightColor.yellow: 1,
    LightColor.red: 3,
    LightColor.green: 3,
  };

  static const _colorsCycle = [
    LightColor.red,
    LightColor.yellow,
    LightColor.green,
    LightColor.yellow,
  ];

  void start() async {
    if (!state.isPaused) return;

    emit(state.copyWith(isPaused: false));

    _nextColor();
  }

  void stop() async {
    if (state.isPaused) return;

    emit(state.copyWith(isPaused: true, isBlinking: false));
  }

  void _nextColor() async {
    if (state.isPaused) return;

    _currColorIndex = (_currColorIndex + 1) % 4;
    final nextColor = _colorsCycle[_currColorIndex];
    if (nextColor == LightColor.green) {
      _scheduleBlinking(
        Duration(seconds: _lightsDurations[LightColor.green]! - 1),
      );
    }

    emit(state.copyWith(currentColor: nextColor, isBlinking: false));

    Future.delayed(
      Duration(seconds: _lightsDurations[nextColor]!),
    ).then((_) => _nextColor());
  }

  void _scheduleBlinking(Duration delay) async {
    await Future.delayed(delay);
    emit(state.copyWith(isBlinking: true));
  }

  Future<void> fetchLightsDurations() async {
    final useCase = getIt<GetLightDurationUseCase>();

    final Map<LightColor, int> durations = {};

    await Future.wait(
      LightColor.values.map((color) async {
        final value = await useCase.getLightDuration(color);
        durations.putIfAbsent(color, () => value);
      }),
    );

    _lightsDurations = durations;
  }
}
