import 'package:ukrposhtatest/common.dart';
import 'package:ukrposhtatest/domain/entities/traffic_light.dart';
import 'package:ukrposhtatest/domain/repositories/traffic_light_repository.dart';

class GetLightModeUseCase {
  Stream<TrafficLightMode> get lightModeStream =>
      getIt<TrafficLightRepository>().lightModeStream;

  const GetLightModeUseCase();

  Future<void> setTrafficLightMode(TrafficLightMode mode) async {
    await getIt<TrafficLightRepository>().setTrafficLightMode(mode);
  }
}
