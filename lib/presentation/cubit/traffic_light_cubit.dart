import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukrposhtatest/domain/entities/light_color.dart';
import 'package:ukrposhtatest/domain/get_light_duration_use_case.dart';
import 'package:ukrposhtatest/domain/get_mode_use_case.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_state.dart';

import '../../common.dart';

class TrafficLightCubit extends Cubit<TrafficLightState> {
  TrafficLightCubit() : super(TrafficLightState.regular(_defaultColor));

  int _currColorIndex = _defaultColorIndex;
  Map<LightColor, Duration> _lightsDurations = defaultLightsDurations;

  Timer? _nextColorTimer;
  Timer? _modeRequester;

  static const int _defaultColorIndex = 0;

  static LightColor get _defaultColor => _colorsCycle[_defaultColorIndex];

  static const Map<LightColor, Duration> defaultLightsDurations = {
    LightColor.red: Duration(seconds: 3),
    LightColor.yellow: Duration(seconds: 1),
    LightColor.green: Duration(seconds: 3),
  };

  static const _colorsCycle = [
    LightColor.red,
    LightColor.yellow,
    LightColor.green,
    LightColor.yellow,
  ];

  Duration get _currDuration =>
      _lightsDurations[_colorsCycle[_currColorIndex]]!;

  void start() {
    _scheduleNextColor();
    _fetchLightsDurations();
    _fetchLightMode();
  }

  void resume() {
    _runRegular();
  }

  void _runRegular() {
    if (state is RegularTrafficLightState) return;

    if (!state.isOn) {
      _fetchLightMode();
    }

    _currColorIndex = _defaultColorIndex;
    emit(TrafficLightState.regular(_colorsCycle[_currColorIndex]));

    /* not calling _nextColor() here, because it'd change curr color (red)
     immediately */
    _scheduleNextColor();
  }

  void stop() {
    if (state is StoppedTrafficLightState) return;

    _cancelLightCycleTimer();
    emit(TrafficLightState.stopped());
    _cancelModeMonitoring();
  }

  void runBlinkingYellow() {
    if (state is BlinkingYellowTrafficLightState) return;

    if (!state.isOn) {
      _fetchLightMode();
    }

    emit(TrafficLightState.blinkingYellow());
    _cancelLightCycleTimer();
  }

  void _nextColor() {
    if (state is! RegularTrafficLightState) return;

    _currColorIndex = (_currColorIndex + 1) % 4;
    final nextColor = _colorsCycle[_currColorIndex];

    emit(TrafficLightState.regular(nextColor));

    _scheduleNextColor();
  }

  void _scheduleNextColor() {
    final delay = _currDuration;
    _nextColorTimer = Timer(delay, _nextColor);
  }

  void _cancelLightCycleTimer() {
    _nextColorTimer?.cancel();
    _nextColorTimer = null;
  }

  Future<void> _fetchLightMode() async {
    final useCase = getIt<GetTrafficLightModeUseCase>();

    _modeRequester = Timer.periodic(Duration(seconds: 2), (_) async {
      if (!state.isOn) return;

      final mode = await useCase.getTrafficLightMode();

      if (mode == TrafficLightMode.blinkingYellow &&
          state is! BlinkingYellowTrafficLightState) {
        runBlinkingYellow();
      } else if (mode == TrafficLightMode.regular &&
          state is! RegularTrafficLightState) {
        _runRegular();
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
    _cancelLightCycleTimer();
    _cancelModeMonitoring();

    super.close();
  }
}
