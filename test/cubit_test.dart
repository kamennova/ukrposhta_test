import 'package:test/test.dart';
import 'package:ukrposhtatest/common.dart';
import 'package:ukrposhtatest/domain/entities/light_color.dart';
import 'package:ukrposhtatest/domain/get_light_duration_use_case.dart';
import 'package:ukrposhtatest/domain/get_mode_use_case.dart';
import 'package:ukrposhtatest/domain/repositories/traffic_light_repository.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_cubit.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_state.dart';

import 'mocks.dart';

void main() {
  group(TrafficLightCubit, () {
    late TrafficLightCubit trafficLightCubit;

    setUpAll(() {
      getIt.registerSingleton<TrafficLightRepository>(
        TestMockTrafficLightRepository(),
      );
      getIt.registerSingleton<GetLightDurationUseCase>(
        GetLightDurationUseCase(),
      );
      getIt.registerSingleton<GetLightModeUseCase>(
        GetLightModeUseCase(),
      );
    });

    setUp(() {
      trafficLightCubit = TrafficLightCubit();
      trafficLightCubit.start();
    });

    tearDown(() {
      trafficLightCubit.close();
    });

    test("init state is red", () {
      expect(trafficLightCubit.state.currentColor, equals(LightColor.red));
    });

    test("start stop works", () {
      expect(trafficLightCubit.state.currentColor, isNot(null));

      trafficLightCubit.stop();
      expect(trafficLightCubit.state.currentColor, equals(null));
      expect(trafficLightCubit.state, isA<StoppedTrafficLightState>());

      trafficLightCubit.resume();
      expect(trafficLightCubit.state.currentColor, isNot(null));
    });

    /* test("blinking yellow works", () async {
      expect(trafficLightCubit.state.currentColor, equals(LightColor.red));

      getIt<TrafficLightRepository>().setTrafficLightMode(TrafficLightMode.blinkingYellow);

      await Future.delayed(Duration(seconds: 1));

      expect(trafficLightCubit.state.currentColor, equals(LightColor.yellow));
      expect(trafficLightCubit.state, isA<BlinkingYellowTrafficLightState>());

      getIt<TrafficLightRepository>().setTrafficLightMode(TrafficLightMode.regular);
    }); */

    test("colors change", () async {
      expect(trafficLightCubit.state.currentColor, equals(LightColor.red));
      await Future.delayed(Duration(seconds: 3));
      expect(trafficLightCubit.state.currentColor, equals(LightColor.yellow));

      await Future.delayed(Duration(seconds: 1));
      expect(trafficLightCubit.state.currentColor, equals(LightColor.green));

      await Future.delayed(Duration(seconds: 3));
      expect(trafficLightCubit.state.currentColor, equals(LightColor.yellow));

      await Future.delayed(Duration(seconds: 1));
      expect(trafficLightCubit.state.currentColor, equals(LightColor.red));
    });
  });
}
