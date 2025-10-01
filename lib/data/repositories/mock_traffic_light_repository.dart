import 'package:ukrposhtatest/domain/entities/light_color.dart';
import 'package:ukrposhtatest/domain/repositories/traffic_light_repository.dart';

class MockTrafficLightRepository implements TrafficLightRepository {
  MockTrafficLightRepository();

  TrafficLightMode _currMode = TrafficLightMode.regular;

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
  Future<TrafficLightMode> getTrafficLightMode() async {
    await Future.delayed(Duration(seconds: 1));
    return _currMode;
  }

  @override
  Future<void> setTrafficLightMode(TrafficLightMode mode) async {
    _currMode = mode;
  }
}
