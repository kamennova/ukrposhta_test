import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_cubit.dart';
import 'package:ukrposhtatest/presentation/view/widgets/mode_switcher.dart';
import 'package:ukrposhtatest/presentation/view/widgets/start_stop_button.dart';
import 'package:ukrposhtatest/presentation/view/widgets/traffic_light_widget.dart';

class TrafficLightPage extends StatelessWidget {
  const TrafficLightPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = TrafficLightCubit();
        cubit.initialize();

        return cubit;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade200,
          title: const Text("Ukrposhta test task"),
        ),
        body: const Padding(
          padding: EdgeInsets.all(6),
          child: Column(
            children: [
              Flexible(child: Center(child: TrafficLightWidget())),
              ModeSwitcher(),
              SizedBox(height: 10),
              StartStopButton(),
            ],
          ),
        ),
      ),
    );
  }
}
