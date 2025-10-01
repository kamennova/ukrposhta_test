import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukrposhtatest/domain/entities/light_color.dart';
import 'package:ukrposhtatest/domain/get_light_duration_use_case.dart';
import 'package:ukrposhtatest/domain/get_mode_use_case.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_state.dart';

import '../../common.dart';

class TrafficLightCubit extends Cubit<TrafficLightState> {
  TrafficLightCubit() : super(TrafficLightState.regular(_defaultColor));

  int _currColorIndex = _defaultIndex;
  Map<LightColor, Duration> _lightsDurations = defaultLightsDurations;

  Timer? _scheduledBlink;
  Timer? _nextColorTimer;
  Timer? _modeRequester;

  static const int _defaultIndex = 0;

  static LightColor get _defaultColor => _colorsCycle[_defaultIndex];

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

  Duration get _currDuration =>
      _lightsDurations[_colorsCycle[_currColorIndex]]!;

  void start() {
    _scheduleNextColor(_currDuration);
    _fetchLightsDurations();
    _initModeMonitoring();
  }

  void runRegular() {
    if (state.isRegular) return;

    if (!state.isOn) {
      _initModeMonitoring();
    }

    emit(TrafficLightState.regular(_colorsCycle[_currColorIndex]));

    _nextColor();
  }

  void stop() {
    if (state is StoppedTrafficLightState) return;

    emit(TrafficLightState.stopped());
    _finishRegularMode();
    _cancelModeMonitoring();
  }

  void runBlinkingYellow() {
    if (state is BlinkingYellowTrafficLightState) return;

    if (!state.isOn) {
      _initModeMonitoring();
    }

    emit(TrafficLightState.blinkingYellow());
    _finishRegularMode();
  }

  void _nextColor() {
    if (!state.isRegular) return;

    _currColorIndex = (_currColorIndex + 1) % 4;
    final nextColor = _colorsCycle[_currColorIndex];
    final nextDuration = _lightsDurations[nextColor]!;

    if (nextColor == LightColor.green) {
      _scheduleBlinkingGreen(
        Duration(
          milliseconds: nextDuration.inMilliseconds - _greenBlinkDurationMs,
        ),
      );
    }

    emit(TrafficLightState.regular(nextColor));

    _scheduleNextColor(nextDuration);
  }

  void _scheduleNextColor(Duration delay) {
    _nextColorTimer = Timer(delay, _nextColor);
  }

  void _finishRegularMode() {
    _currColorIndex = _defaultIndex;
    _cancelLightTimers();
  }

  void _cancelLightTimers() {
    _scheduledBlink?.cancel();
    _scheduledBlink = null;

    _nextColorTimer?.cancel();
    _nextColorTimer = null;
  }

  void _scheduleBlinkingGreen(Duration delay) async {
    _scheduledBlink = Timer(delay, () {
      if (state.isRegular) {
        emit(TrafficLightState.blinkingGreen());
      }
    });
  }

  Future<void> _initModeMonitoring() async {
    final useCase = getIt<GetTrafficLightModeUseCase>();

    _modeRequester = Timer.periodic(Duration(seconds: 2), (_) async {
      if (!state.isOn) return;

      final mode = await useCase.getTrafficLightMode();

      if (mode == TrafficLightMode.blinkingYellow) {
        runBlinkingYellow();
      } else if (mode == TrafficLightMode.regular) {
        runRegular();
      }
    });
  }

  void _cancelModeMonitoring() {
    _modeRequester?.cancel();
    _modeRequester = null;
  }

  Future<void> _fetchLightsDurations() async {
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

  @override
  Future<void> close() async {
    _cancelLightTimers();
    _cancelModeMonitoring();

    super.close();
  }
}
