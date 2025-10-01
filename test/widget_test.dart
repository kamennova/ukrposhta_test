// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ukrposhtatest/common.dart';
import 'package:ukrposhtatest/domain/get_light_duration_use_case.dart';
import 'package:ukrposhtatest/domain/get_mode_use_case.dart';
import 'package:ukrposhtatest/domain/repositories/traffic_light_repository.dart';
import 'package:ukrposhtatest/main.dart';

import 'mocks.dart';

void main() {
  setUpAll(() {
    getIt.registerSingleton<TrafficLightRepository>(
      TestMockTrafficLightRepository(),
    );
    getIt.registerSingleton<GetLightDurationUseCase>(GetLightDurationUseCase());
    getIt.registerSingleton<GetTrafficLightModeUseCase>(
      GetTrafficLightModeUseCase(),
    );
  });

  testWidgets('correct colors light up', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    var red = find.byKey(Key("light-red"));
    expect(red, findsOneWidget);

    var redWidget = tester.firstWidget(red) as Container;
    var decoration = redWidget.decoration as BoxDecoration;
    expect(decoration.color, equals(Colors.red));

    await tester.pump(Duration(seconds: 3));

    var yellow = find.byKey(Key("light-yellow"));
    expect(yellow, findsOneWidget);

    var yellowWidget = tester.firstWidget(yellow) as Container;
    decoration = yellowWidget.decoration as BoxDecoration;
    expect(decoration.color, equals(Colors.yellow));

    await tester.pump(Duration(seconds: 1));

    final green = find.byKey(Key("light-green"));
    expect(green, findsOneWidget);

    final greenWidget = tester.firstWidget(green) as Container;
    decoration = greenWidget.decoration as BoxDecoration;
    expect(decoration.color, equals(Colors.green));

    await tester.pump(Duration(seconds: 3));

    yellowWidget = tester.firstWidget(yellow) as Container;
    decoration = yellowWidget.decoration as BoxDecoration;
    expect(decoration.color, equals(Colors.yellow));

    await tester.pump(Duration(seconds: 1));

    redWidget = tester.firstWidget(red) as Container;
    decoration = redWidget.decoration as BoxDecoration;
    expect(decoration.color, equals(Colors.red));
  });
}
