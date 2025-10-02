import 'package:ukrposhtatest/domain/repositories/traffic_light_repository.dart';

import '../common.dart';
import 'entities/light_color.dart';

class GetLightModeUseCase {
  const GetLightModeUseCase();

  Stream<TrafficLightMode> get lightModeStream =>
      getIt<TrafficLightRepository>().lightModeStream;

  Future<void> setTrafficLightMode(TrafficLightMode mode) async {
    await getIt<TrafficLightRepository>().setTrafficLightMode(mode);
  }
}
