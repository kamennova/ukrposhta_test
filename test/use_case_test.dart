import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:ukrposhtatest/common.dart';
import 'package:ukrposhtatest/domain/entities/light_color.dart';
import 'package:ukrposhtatest/domain/get_light_duration_use_case.dart';
import 'package:ukrposhtatest/domain/get_mode_use_case.dart';
import 'package:ukrposhtatest/domain/repositories/traffic_light_repository.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_cubit.dart';

class MockTrafficLightRepository extends Mock
    implements TrafficLightRepository {
  @override
  Future<Duration> getLightDuration(LightColor color) async {
    switch (color) {
      case LightColor.red:
        return Duration(seconds: 10);
      case LightColor.yellow:
        return Duration(seconds: 5);
      case LightColor.green:
        return Duration(milliseconds: 500);
    }
  }

  @override
  Future<TrafficLightMode> getTrafficLightMode() async {
    return TrafficLightMode.blinkingYellow;
  }
}

void main() {
  group(TrafficLightCubit, () {
    late GetLightDurationUseCase durationUseCase;
    late GetTrafficLightModeUseCase modeUseCase;
    late TrafficLightRepository repository;

    setUpAll(() {
      repository = MockTrafficLightRepository();
      getIt.registerSingleton<TrafficLightRepository>(repository);
      durationUseCase = GetLightDurationUseCase();
      modeUseCase = GetTrafficLightModeUseCase();
    });

    test("check light duration values are fetched from repo", () async {
      expect(
        await durationUseCase.getLightDuration(LightColor.red),
        equals(Duration(seconds: 10)),
      );
      expect(
        await durationUseCase.getLightDuration(LightColor.yellow),
        equals(Duration(seconds: 5)),
      );
      expect(
        await durationUseCase.getLightDuration(LightColor.green),
        equals(Duration(milliseconds: 500)),
      );
    });

    test("check light mode value is fetched from repo", () async {
      expect(
        await modeUseCase.getTrafficLightMode(),
        equals(TrafficLightMode.blinkingYellow),
      );
    });
  });
}
