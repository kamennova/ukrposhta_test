import 'dart:async';

import 'package:ukrposhtatest/domain/entities/traffic_light.dart';
import 'package:ukrposhtatest/domain/repositories/traffic_light_repository.dart';

/// this exposes light mode change events stream and
/// methods for getting specific light color duration and setting light mode
class MockTrafficLightRepository implements TrafficLightRepository {
  static const _defaultTrafficLightMode = TrafficLightMode.regular;

  static const Map<LightColor, Duration> defaultLightsDurations = {
    LightColor.red: Duration(seconds: 3),
    LightColor.yellow: Duration(seconds: 1),
    LightColor.green: Duration(seconds: 3),
  };

  TrafficLightMode _currMode = _defaultTrafficLightMode;

  late final StreamController<TrafficLightMode> _modeController =
      StreamController.broadcast(
        onListen: () {
          _modeController.add(_currMode);
        },
      );

  @override
  Stream<TrafficLightMode> get lightModeStream => _modeController.stream;

  MockTrafficLightRepository();

  @override
  Future<Duration> getLightDuration(LightColor color) async {
    await Future.delayed(const Duration(seconds: 1));

    return defaultLightsDurations[color]!;
  }

  @override
  Future<void> setTrafficLightMode(TrafficLightMode mode) async {
    await Future.delayed(const Duration(seconds: 1));
    _currMode = mode;
    _modeController.add(_currMode);
  }
}
