import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukrposhtatest/domain/entities/light_color.dart';
import 'package:ukrposhtatest/domain/get_duration_use_case.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_state.dart';

import '../../common.dart';

class TrafficLightCubit extends Cubit<TrafficLightState> {
  TrafficLightCubit() : super(const TrafficLightState.regular(_defaultColor));

  int _currColorIndex = _defaultIndex;
  Map<LightColor, Duration> _lightsDurations = defaultLightsDurations;

  Timer? _scheduledBlink;
  Timer? _nextColorTimer;

  static const LightColor _defaultColor = LightColor.red;
  static const int _defaultIndex = 0;

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

  static const _greenBlinkDurationMs = 700;

  void start() {
    _nextColor();
    fetchLightsDurations();
  }

  void runRegular() {
    if (state.isRegular) return;

    emit(TrafficLightState.regular(_colorsCycle[_currColorIndex]));

    _nextColor();
  }

  void stop() {
    if (state is StoppedTrafficLightState) return;
    emit(TrafficLightState.stopped());
    _finishRegularMode();
  }

  void runBlinkingYellow() {
    if (state is BlinkingYellowTrafficLightState) return;
    emit(TrafficLightState.blinkingYellow());
    _finishRegularMode();
  }

  void _nextColor() {
    if (!state.isRegular) return;

    _currColorIndex = (_currColorIndex + 1) % 4;
    final nextColor = _colorsCycle[_currColorIndex];
    final nextDuration = _lightsDurations[nextColor]!;

    if (nextColor == LightColor.green) {
      _scheduleBlinking(
        Duration(
          milliseconds: nextDuration.inMilliseconds - _greenBlinkDurationMs,
        ),
      );
    }

    emit(TrafficLightState.regular(nextColor));

    _nextColorTimer = Timer(nextDuration, _nextColor);
  }

  void _finishRegularMode() {
    _currColorIndex = _defaultIndex;

    _scheduledBlink?.cancel();
    _scheduledBlink = null;

    _nextColorTimer?.cancel();
    _nextColorTimer = null;
  }

  void _scheduleBlinking(Duration delay) async {
    _scheduledBlink = Timer(delay, () async {
      if (state.isRegular) {
        emit(TrafficLightState.blinkingGreen());
      }
    });
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
