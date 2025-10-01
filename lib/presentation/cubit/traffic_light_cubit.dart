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
  final Map<LightColor, Duration> _lightsDurations = {...defaultLightsDurations};

  Timer? _nextColorTimer;
  StreamSubscription<TrafficLightMode>? _modeSubscription;
  TrafficLightMode _lastMode = TrafficLightMode.regular;

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

  LightColor get _currColor => _colorsCycle[_currColorIndex];

  void start() {
    _scheduleNextColor();
    _fetchLightsDurations();
    _subscribeToLightMode();
  }

  void resume() {
    if (_lastMode == TrafficLightMode.regular) {
      _runRegular();
    } else {
      _runBlinkingYellow();
    }
  }

  void _runRegular() {
    if (state is RegularTrafficLightState) return;

    if (!state.isOn) {
      _onResumed();
    }

    _currColorIndex = _defaultColorIndex;
    emit(TrafficLightState.regular(_currColor));

    /* not calling _nextColor() here, because it'd change curr color (red)
     immediately */
    _scheduleNextColor();
  }

  void stop() {
    if (state is StoppedTrafficLightState) return;

    _cancelLightCycleTimer();
    emit(TrafficLightState.stopped());
    _modeSubscription?.pause();
  }

  void _runBlinkingYellow() {
    if (state is BlinkingYellowTrafficLightState) return;

    if (!state.isOn) {
      _onResumed();
    }

    emit(TrafficLightState.blinkingYellow());
    _cancelLightCycleTimer();
  }

  void _onResumed() {
    _modeSubscription?.resume();
  }

  void _nextColor() {
    if (state is! RegularTrafficLightState) return;

    _currColorIndex = (_currColorIndex + 1) % 4;
    emit(TrafficLightState.regular(_currColor));

    _scheduleNextColor();
  }

  void _scheduleNextColor() {
    final delay = _lightsDurations[_currColor]!;
    _nextColorTimer = Timer(delay, _nextColor);
  }

  void _cancelLightCycleTimer() {
    _nextColorTimer?.cancel();
    _nextColorTimer = null;
  }

  Future<void> _subscribeToLightMode() async {
    final useCase = getIt<GetLightModeUseCase>();

    _modeSubscription = useCase.lightModeStream.listen((value) {
      _lastMode = value;
      if (!state.isOn) return;

      if (value == TrafficLightMode.blinkingYellow &&
          state is! BlinkingYellowTrafficLightState) {
        _runBlinkingYellow();
      } else if (value == TrafficLightMode.regular &&
          state is! RegularTrafficLightState) {
        _runRegular();
      }
    });
  }

  Future<void> _fetchLightsDurations() async {
    final useCase = getIt<GetLightDurationUseCase>();

    await Future.wait(
      LightColor.values.map((color) async {
        final value = await useCase.getLightDuration(color);
        _lightsDurations.putIfAbsent(color, () => value);
      }),
    );
  }

  @override
  Future<void> close() async {
    _cancelLightCycleTimer();
    _modeSubscription?.cancel();

    super.close();
  }
}
