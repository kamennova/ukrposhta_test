import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/light_color.dart';
import '../../cubit/traffic_light_cubit.dart';
import '../../cubit/traffic_light_state.dart';

class ModeSwitcher extends StatelessWidget {
  const ModeSwitcher({super.key});

  Widget _getLabel(TrafficLightMode mode, String label, BuildContext context) {
    return GestureDetector(
      onTap: () => _setMode(mode, context),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Text(label, style: TextStyle(fontSize: 17)),
      ),
    );
  }

  void _setMode(TrafficLightMode mode, BuildContext context) {
    final cubit = context.read<TrafficLightCubit>();

    if (!cubit.state.isOn) return;

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
        final bool isEnabled = state.isOn;

        return Opacity(
          opacity: isEnabled ? 1 : 0.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _getLabel(TrafficLightMode.regular, "Regular", context),
              Switch(
                trackColor: WidgetStatePropertyAll(Colors.grey.shade600),
                activeColor: Colors.yellow,
                inactiveThumbColor: Colors.white,
                value: state is BlinkingYellowTrafficLightState,
                onChanged:
                    isEnabled
                        ? (value) => _setMode(
                          value
                              ? TrafficLightMode.blinkingYellow
                              : TrafficLightMode.regular,
                          context,
                        )
                        : null,
              ),
              _getLabel(
                TrafficLightMode.blinkingYellow,
                "Blinking yellow",
                context,
              ),
            ],
          ),
        );
      },
    );
  }
}
