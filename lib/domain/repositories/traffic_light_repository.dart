import 'package:ukrposhtatest/domain/entities/traffic_light.dart';

abstract interface class TrafficLightRepository {
  Stream<TrafficLightMode> get lightModeStream;

  Future<Duration> getLightDuration(LightColor color);

  Future<void> setTrafficLightMode(TrafficLightMode mode);
}
