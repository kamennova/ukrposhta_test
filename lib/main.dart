import 'package:flutter/material.dart';
import 'package:ukrposhtatest/data/repositories/mock_traffic_light_repository.dart';
import 'package:ukrposhtatest/domain/get_duration_use_case.dart';
import 'package:ukrposhtatest/domain/repositories/traffic_light_repository.dart';
import 'package:ukrposhtatest/presentation/view/traffic_light_page.dart';

import 'common.dart';

void main() {
  getIt.registerSingleton<TrafficLightRepository>(
    const MockTrafficLightRepository(),
  );
  getIt.registerSingleton<GetLightDurationUseCase>(GetLightDurationUseCase());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return TrafficLightPage();
  }
}
