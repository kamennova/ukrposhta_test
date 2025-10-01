import 'package:flutter/material.dart';
import 'package:ukrposhtatest/data/repositories/mock_traffic_light_repository.dart';
import 'package:ukrposhtatest/domain/get_light_duration_use_case.dart';
import 'package:ukrposhtatest/domain/get_mode_use_case.dart';
import 'package:ukrposhtatest/domain/repositories/traffic_light_repository.dart';
import 'package:ukrposhtatest/presentation/view/traffic_light_page.dart';

import 'common.dart';

void main() {
  getIt.registerSingleton<TrafficLightRepository>(
    MockTrafficLightRepository(),
  );
  getIt.registerSingleton<GetLightDurationUseCase>(GetLightDurationUseCase());
  getIt.registerSingleton<GetTrafficLightModeUseCase>(GetTrafficLightModeUseCase());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ukrposhta test task',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
      ),
      home: const TrafficLightPage(),
    );
  }
}
