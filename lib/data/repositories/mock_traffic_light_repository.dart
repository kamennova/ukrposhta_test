import 'package:ukrposhtatest/domain/entities/light_color.dart';
import 'package:ukrposhtatest/domain/repositories/traffic_light_repository.dart';

class MockTrafficLightRepository implements TrafficLightRepository {
  const MockTrafficLightRepository();

  @override
  Future<int> getLightDuration(LightColor color) async {
    await Future.delayed(Duration(seconds: 1));
    switch (color) {
      case LightColor.green: return 3;
      case LightColor.yellow: return 1;
      case LightColor.red: return 3;
    }
  }
}