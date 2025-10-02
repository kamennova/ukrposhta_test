import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:ukrposhtatest/data/repositories/mock_traffic_light_repository.dart';
import 'package:ukrposhtatest/domain/entities/traffic_light.dart';
import 'package:ukrposhtatest/domain/repositories/traffic_light_repository.dart';

class TestMockTrafficLightRepository extends Mock
    implements TrafficLightRepository {
  final TrafficLightMode _mode;
  final Map<LightColor, Duration> _durations;

  late final StreamController<TrafficLightMode> _modeController =
      StreamController.broadcast(
        onListen: () {
          _modeController.add(_mode);
        },
      );

  TestMockTrafficLightRepository({
    TrafficLightMode mode = TrafficLightMode.regular,
    Map<LightColor, Duration> durations =
        MockTrafficLightRepository.defaultLightsDurations,
  }) : _mode = mode,
       _durations = durations;

  @override
  Future<Duration> getLightDuration(LightColor color) async {
    return _durations[color]!;
  }

  @override
  Stream<TrafficLightMode> get lightModeStream => _modeController.stream;
}
