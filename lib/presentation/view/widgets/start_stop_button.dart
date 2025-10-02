import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/traffic_light_cubit.dart';
import '../../cubit/traffic_light_state.dart';

class StartStopButton extends StatelessWidget {
  const StartStopButton({super.key});

  void _toggleTrafficLight(BuildContext context) {
    final cubit = context.read<TrafficLightCubit>();
    if (cubit.state is StoppedTrafficLightState) {
      cubit.run();
    } else {
      cubit.stop();
    }
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<TrafficLightCubit, TrafficLightState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 6,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                ),
                onPressed: () => _toggleTrafficLight(context),
                child: Column(
                  children: [
                    state.isOn
                        ? Icon(Icons.stop, size: 30)
                        : Icon(Icons.play_arrow, size: 30),
                    SizedBox(height: 5),
                    Text(
                      state.isOn ? "Stop" : "Start",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
