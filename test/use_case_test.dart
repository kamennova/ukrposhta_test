import 'package:test/test.dart';
import 'package:ukrposhtatest/common.dart';
import 'package:ukrposhtatest/domain/entities/traffic_light.dart';
import 'package:ukrposhtatest/domain/get_light_duration_use_case.dart';
import 'package:ukrposhtatest/domain/light_mode_use_case.dart';
import 'package:ukrposhtatest/domain/repositories/traffic_light_repository.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_cubit.dart';

import 'mocks.dart';

void main() {
  group(TrafficLightCubit, () {
    late GetLightDurationUseCase durationUseCase;
    late LightModeUseCase modeUseCase;

    setUpAll(() {
      getIt.registerSingleton<TrafficLightRepository>(
        TestMockTrafficLightRepository(
          mode: TrafficLightMode.blinkingYellow,
          durations: {
            LightColor.red: Duration(seconds: 10),
            LightColor.yellow: Duration(seconds: 5),
            LightColor.green: Duration(milliseconds: 500),
          },
        ),
      );
      durationUseCase = GetLightDurationUseCase();
      modeUseCase = LightModeUseCase();
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
      final initMode = await modeUseCase.lightModeStream.first;

      expect(initMode, equals(TrafficLightMode.blinkingYellow));
    });
  });
}
