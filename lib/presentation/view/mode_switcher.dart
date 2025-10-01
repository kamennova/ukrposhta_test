import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/light_color.dart';
import '../cubit/traffic_light_cubit.dart';
import '../cubit/traffic_light_state.dart';

class ModeSwitcher extends StatelessWidget {
  const ModeSwitcher({super.key});

  Widget _getLabel(TrafficLightMode mode, String label, BuildContext context) {
    return GestureDetector(
      onTap: () => _setMode(mode, context),
      child: Text(label, style: TextStyle(fontSize: 17)),
    );
  }

  void _setMode(TrafficLightMode mode, BuildContext context) {
    final cubit = context.read<TrafficLightCubit>();

    if (mode == TrafficLightMode.regular) {
      cubit.runRegular();
    } else {
      cubit.runBlinkingYellow();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrafficLightCubit, TrafficLightState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getLabel(TrafficLightMode.regular, "Regular", context),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Switch(
                trackColor: WidgetStatePropertyAll(Colors.grey.shade600),
                activeColor: Colors.yellow,
                inactiveThumbColor: Colors.white,
                value: state is BlinkingYellowTrafficLightState,
                onChanged:
                    (value) => _setMode(
                      value
                          ? TrafficLightMode.blinkingYellow
                          : TrafficLightMode.regular,
                      context
                    ),
              ),
            ),
            _getLabel(
              TrafficLightMode.blinkingYellow,
              "Blinking yellow",
              context,
            ),
          ],
        );
      },
    );
  }
}
