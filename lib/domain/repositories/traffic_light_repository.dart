import 'package:ukrposhtatest/domain/entities/light_color.dart';

abstract interface class TrafficLightRepository {
  Future<Duration> getLightDuration(LightColor color);

  Future<void> setTrafficLightMode(TrafficLightMode mode);

  Stream<TrafficLightMode> get lightModeStream;
}
