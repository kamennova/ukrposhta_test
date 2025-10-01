import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukrposhtatest/domain/entities/light_color.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_cubit.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_state.dart';
import 'package:ukrposhtatest/presentation/view/start_stop_button.dart';

import 'light_widget.dart';
import 'mode_switcher.dart';

class TrafficLightPage extends StatelessWidget {
  const TrafficLightPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = TrafficLightCubit();
        cubit.start();
        return cubit;
      },
      child: _View(),
    );
  }
}

class _View extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VState();
}

class _VState extends State<_View> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  void _toggleTrafficLight() {
    final cubit = context.read<TrafficLightCubit>();
    if (!cubit.state.isOn) {
      cubit.runRegular();
    } else {
      cubit.stop();
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.value = 1;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TrafficLightCubit, TrafficLightState>(
      listener: (context, state) {
        if (state.isBlinking) {
          if (!_animationController.isAnimating) {
            _animationController.repeat(reverse: true);
          }
        } else {
          if (_animationController.isAnimating) {
            _animationController.stop();
            _animationController.value = 1;
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade200,
          title: Text("Ukrposhta test task"),
        ),
        body: BlocBuilder<TrafficLightCubit, TrafficLightState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Flexible(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          spacing: 6,
                          mainAxisSize: MainAxisSize.min,
                          children:
                              [
                                    LightColor.red,
                                    LightColor.yellow,
                                    LightColor.green,
                                  ]
                                  .map(
                                    (color) => TrafficLightCircle(
                                      animation: _animation,
                                      color: color,
                                      isActive: state.currentColor == color,
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  const ModeSwitcher(),
                  SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BigButton(
                        onPressed: _toggleTrafficLight,
                        icon:
                            state.isOn
                                ? Icon(Icons.stop, size: 30)
                                : Icon(Icons.play_arrow, size: 30),
                        label: state.isOn ? "Stop" : "Start",
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
