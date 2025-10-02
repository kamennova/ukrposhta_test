import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukrposhtatest/common.dart';
import 'package:ukrposhtatest/domain/entities/traffic_light.dart';
import 'package:ukrposhtatest/domain/get_light_duration_use_case.dart';
import 'package:ukrposhtatest/domain/light_mode_use_case.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_state.dart';

class TrafficLightCubit extends Cubit<TrafficLightState> {
  int _currColorIndex = _defaultColorIndex;
  Map<LightColor, Duration> _lightsDurations = _defaultLightsDurations;
  TrafficLightMode _currLightMode = TrafficLightMode.regular;

  Timer? _nextColorTimer;
  Timer? _lightDurationsFetcherTimer;
  StreamSubscription<TrafficLightMode>? _modeSubscription;

  static const int _defaultColorIndex = 0;

  static const Map<LightColor, Duration> _defaultLightsDurations = {
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

  TrafficLightCubit() :
        super(TrafficLightState.regular(_colorsCycle[_defaultColorIndex]));

  /// should be called on cubit create, when ready to start traffic light.
  /// starts traffic light in regular mode, initializes monitoring of lights 
  /// durations and current light mode (regular or blinking yellow) 
  void initialize() {
    _scheduleNextColor();

    _startLightsDurationsFetcher();
    _subscribeToLightMode();
  }

  /// runs traffic light depending on current mode
  void run() {
    if (!state.isOn) {
      _onResumed();
    }

    if (_currLightMode == TrafficLightMode.regular) {
      _startRegular();
    } else {
      _startBlinkingYellow();
    }
  }

  void _startRegular() {
    if (state is RegularTrafficLightState) return;

    _currColorIndex = _defaultColorIndex;
    emit(TrafficLightState.regular(_currColor));

    /* not calling _nextColor() here, because it'd change curr color (red)
     immediately */
    _scheduleNextColor();
  }

  /// turns of traffic lights, pauses monitoring of lights durations and mode
  void stop() {
    if (state is StoppedTrafficLightState) return;

    _cancelLightCycleTimer();
    emit(const TrafficLightState.stopped());

    _modeSubscription?.pause();
    _cancelLightDurationsUpdater();
  }

  void _startBlinkingYellow() {
    if (state is BlinkingYellowTrafficLightState) return;

    emit(const TrafficLightState.blinkingYellow());
    _cancelLightCycleTimer();
  }

  void _onResumed() {
    _modeSubscription?.resume();
    _startLightsDurationsFetcher();
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
    final useCase = getIt<LightModeUseCase>();

    _modeSubscription = useCase.lightModeStream.listen((value) {
      _currLightMode = value;
      if (state.isOn) {
        run();
      }
    });
  }

  void _startLightsDurationsFetcher() {
    if (_lightDurationsFetcherTimer != null) {
      log("sdf");
    }
    _lightDurationsFetcherTimer = Timer.periodic(
      const Duration(minutes: 2),
      (_) => _fetchLightsDurations(),
    );
  }

  void _cancelLightDurationsUpdater() {
    _lightDurationsFetcherTimer?.cancel();
    _lightDurationsFetcherTimer = null;
  }

  Future<void> _fetchLightsDurations() async {
    final useCase = getIt<GetLightDurationUseCase>();

    try {
      final Map<LightColor, Duration> durationsUpd = {};

      await Future.wait(
        LightColor.values.map((color) async {
          final value = await useCase.getLightDuration(color);
          durationsUpd.putIfAbsent(color, () => value);
        }),
      ).timeout(const Duration(seconds: 30));

      _lightsDurations = durationsUpd;
    } catch (e) {
      log("fetch light duration timeout, $e");
    }
  }

  @override
  Future<void> close() async {
    _cancelLightCycleTimer();
    _cancelLightDurationsUpdater();
    _modeSubscription?.cancel();

    super.close();
  }
}
