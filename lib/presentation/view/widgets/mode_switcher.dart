import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukrposhtatest/domain/get_mode_use_case.dart';

import '../../../common.dart';
import '../../../domain/entities/light_color.dart';
import '../../cubit/traffic_light_cubit.dart';
import '../../cubit/traffic_light_state.dart';

class ModeSwitcher extends StatefulWidget {
  const ModeSwitcher({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ModeSwitcher> {
  bool _isLoading = false;

  Widget _getLabel(TrafficLightMode mode, String label) {
    return GestureDetector(
      onTap: () => _setMode(mode),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(label, style: TextStyle(fontSize: 17)),
      ),
    );
  }

  void _setMode(TrafficLightMode mode) async {
    setState(() {
      _isLoading = true;
    });
    await getIt<GetLightModeUseCase>().setTrafficLightMode(mode);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrafficLightCubit, TrafficLightState>(
      builder: (context, state) {
        final bool isEnabled = state.isOn;

        final modeSwitch = Switch(
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
                  )
                  : null,
        );

        final loadingIndicator = SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            padding: EdgeInsets.zero,
            strokeAlign: 1,
          ),
        );

        return Opacity(
          opacity: isEnabled ? 1 : 0.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _getLabel(TrafficLightMode.regular, "Regular"),
              SizedBox(
                width: 60,
                height: 35,
                child: Center(
                  child: _isLoading ? loadingIndicator : modeSwitch,
                ),
              ),
              _getLabel(TrafficLightMode.blinkingYellow, "Blinking yellow"),
            ],
          ),
        );
      },
    );
  }
}
