import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukrposhtatest/domain/entities/light_color.dart';
import 'package:ukrposhtatest/domain/get_light_duration_use_case.dart';
import 'package:ukrposhtatest/domain/get_mode_use_case.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_state.dart';

import '../../common.dart';

class TrafficLightCubit extends Cubit<TrafficLightState> {
  TrafficLightCubit() : super(TrafficLightState.regular(_defaultColor));

  int _currColorIndex = _defaultColorIndex;
  final Map<LightColor, Duration> _lightsDurations = {
    ...defaultLightsDurations,
  };
  TrafficLightMode _currLightMode = TrafficLightMode.regular;

  Timer? _nextColorTimer;
  Timer? _lightDurationsFetcherTimer;
  StreamSubscription<TrafficLightMode>? _modeSubscription;

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

  void initialize() {
    _scheduleNextColor();

    _startLightsDurationsUpdater();
    _subscribeToLightMode();
  }

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

  void stop() {
    if (state is StoppedTrafficLightState) return;

    _cancelLightCycleTimer();
    emit(TrafficLightState.stopped());

    _modeSubscription?.pause();
    _cancelLightDurationsUpdater();
  }

  void _startBlinkingYellow() {
    if (state is BlinkingYellowTrafficLightState) return;

    emit(TrafficLightState.blinkingYellow());
    _cancelLightCycleTimer();
  }

  void _onResumed() {
    _modeSubscription?.resume();
    _startLightsDurationsUpdater();
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
      _currLightMode = value;
      if (state.isOn) {
        run();
      }
    });
  }

  void _startLightsDurationsUpdater() {
    _lightDurationsFetcherTimer = Timer.periodic(Duration(minutes: 2), (_) {
      _fetchLightsDurations();
    });
  }

  void _cancelLightDurationsUpdater() {
    _lightDurationsFetcherTimer?.cancel();
    _lightDurationsFetcherTimer = null;
  }

  Future<void> _fetchLightsDurations() async {
    final useCase = getIt<GetLightDurationUseCase>();

    await Future.wait(
      LightColor.values.map((color) async {
        try {
          final value = await useCase
              .getLightDuration(color)
              .timeout(Duration(seconds: 30));
          _lightsDurations.putIfAbsent(color, () => value);
        } catch (e) {
          log("fetch light duration timeout, ${e}");
        }
      }),
    );
  }

  @override
  Future<void> close() async {
    _cancelLightCycleTimer();
    _modeSubscription?.cancel();
    _cancelLightDurationsUpdater();

    super.close();
  }
}
