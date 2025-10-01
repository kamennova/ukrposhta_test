import 'dart:async';

import 'package:ukrposhtatest/domain/entities/light_color.dart';
import 'package:ukrposhtatest/domain/repositories/traffic_light_repository.dart';

class MockTrafficLightRepository implements TrafficLightRepository {
  MockTrafficLightRepository();

  static const _defaultTrafficLightMode = TrafficLightMode.regular;

  TrafficLightMode _currMode = _defaultTrafficLightMode;

  late final StreamController<TrafficLightMode> _modeController =
      StreamController.broadcast(
        onListen: () {
          _modeController.add(_currMode);
        },
      );

  @override
  Future<Duration> getLightDuration(LightColor color) async {
    await Future.delayed(Duration(seconds: 1));
    switch (color) {
      case LightColor.green:
        return Duration(seconds: 3);
      case LightColor.yellow:
        return Duration(seconds: 1);
      case LightColor.red:
        return Duration(seconds: 3);
    }
  }

  @override
  Future<void> setTrafficLightMode(TrafficLightMode mode) async {
    _currMode = mode;
    _modeController.add(_currMode);
  }

  @override
  Stream<TrafficLightMode> get lightModeStream => _modeController.stream;
}
