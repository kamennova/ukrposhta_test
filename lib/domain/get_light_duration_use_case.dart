import 'package:ukrposhtatest/common.dart';
import 'package:ukrposhtatest/domain/entities/traffic_light.dart';
import 'package:ukrposhtatest/domain/repositories/traffic_light_repository.dart';

class GetLightDurationUseCase {
  const GetLightDurationUseCase();

  Future<Duration> getLightDuration(LightColor color) async {
    return getIt<TrafficLightRepository>().getLightDuration(color);
  }
}
