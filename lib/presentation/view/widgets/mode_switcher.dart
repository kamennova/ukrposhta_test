import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukrposhtatest/common.dart';
import 'package:ukrposhtatest/domain/entities/traffic_light.dart';
import 'package:ukrposhtatest/domain/light_mode_use_case.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_cubit.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_state.dart';

class ModeSwitcher extends StatefulWidget {
  const ModeSwitcher({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ModeSwitcher> {
  bool _isLoading = false;

  Future<void> _setMode(TrafficLightMode mode) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });
    await getIt<LightModeUseCase>().setTrafficLightMode(mode);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrafficLightCubit, TrafficLightState>(
      builder: (_, state) {
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

        const loadingIndicator = SizedBox(
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
              _Label(
                label: "Regular",
                onTap:
                    _isLoading
                        ? null
                        : () => _setMode(TrafficLightMode.regular),
              ),
              SizedBox(
                width: 60,
                height: 35,
                child: Center(
                  child: _isLoading ? loadingIndicator : modeSwitch,
                ),
              ),
              _Label(
                label: "Blinking yellow",
                onTap:
                    _isLoading
                        ? null
                        : () => _setMode(TrafficLightMode.blinkingYellow),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Label extends StatelessWidget {
  final Function()? onTap;
  final String label;

  const _Label({required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(label, style: const TextStyle(fontSize: 17)),
      ),
    );
  }
}
