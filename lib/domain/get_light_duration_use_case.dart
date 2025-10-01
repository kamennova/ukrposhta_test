import 'package:ukrposhtatest/domain/repositories/traffic_light_repository.dart';

import '../common.dart';
import 'entities/light_color.dart';

class GetLightDurationUseCase {
  const GetLightDurationUseCase();

  Future<Duration> getLightDuration(LightColor color) async {
    return await getIt<TrafficLightRepository>().getLightDuration(color);
  }
}