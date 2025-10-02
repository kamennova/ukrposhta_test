import 'package:ukrposhtatest/common.dart';
import 'package:ukrposhtatest/domain/entities/traffic_light.dart';
import 'package:ukrposhtatest/domain/repositories/traffic_light_repository.dart';

class LightModeUseCase {
  Stream<TrafficLightMode> get lightModeStream =>
      getIt<TrafficLightRepository>().lightModeStream;

  const LightModeUseCase();

  Future<void> setTrafficLightMode(TrafficLightMode mode) async {
    await getIt<TrafficLightRepository>().setTrafficLightMode(mode);
  }
}
