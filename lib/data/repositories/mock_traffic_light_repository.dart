import 'package:ukrposhtatest/domain/entities/light_color.dart';
import 'package:ukrposhtatest/domain/repositories/traffic_light_repository.dart';

class MockTrafficLightRepository implements TrafficLightRepository {
  const MockTrafficLightRepository();

  @override
  Future<Duration> getLightDuration(LightColor color) async {
    await Future.delayed(Duration(seconds: 1));
    switch (color) {
      case LightColor.green: return Duration(seconds: 3);
      case LightColor.yellow: return Duration(seconds: 1);
      case LightColor.red: return Duration(seconds: 3);
    }
  }
}