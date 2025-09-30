import 'package:ukrposhtatest/domain/entities/light_color.dart';

// todo interface?
abstract class TrafficLightRepository {
  Future<int> getLightDuration(LightColor color);
}
