import 'package:ukrposhtatest/domain/entities/light_color.dart';

// todo interface?
abstract class TrafficLightRepository {
  Future<Duration> getLightDuration(LightColor color);
}
