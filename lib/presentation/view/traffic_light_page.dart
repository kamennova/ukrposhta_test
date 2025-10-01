import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukrposhtatest/domain/entities/light_color.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_cubit.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_state.dart';
import 'package:ukrposhtatest/presentation/view/start_stop_button.dart';

import 'light_widget.dart';
import 'mode_switcher.dart';

class TrafficLightPage extends StatefulWidget {
  const TrafficLightPage({super.key});

  @override
  State<StatefulWidget> createState() => _TrafficLightState();
}

class _TrafficLightState extends State<TrafficLightPage> {

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
      cubit.start();
    } else {
      cubit.stop();
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);

    _animationController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TrafficLightCubit, TrafficLightState>(
      listener: (context, state) {
        log(state.toString());

        bool shouldBlink =
            state.isBlinking || state.mode == TrafficLightMode.blinkingYellow;

        if (state.isOn && shouldBlink) {
          if (!_animationController.isAnimating) {
            _animationController.repeat();
          }
        } else if (!shouldBlink) {
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
            final isYellow = state.mode == TrafficLightMode.blinkingYellow;

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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TrafficLightCircle(
                              animation: _animation,
                              color: LightColor.red,
                              isActive:
                                  !isYellow &&
                                  state.currentColor == LightColor.red,
                            ),
                            SizedBox(height: 6),
                            TrafficLightCircle(
                              animation: _animation,
                              color: LightColor.yellow,
                              isActive:
                                  isYellow ||
                                  state.currentColor == LightColor.yellow,
                            ),
                            SizedBox(height: 6),
                            TrafficLightCircle(
                              animation: _animation,
                              color: LightColor.green,
                              isActive:
                                  !isYellow &&
                                  state.currentColor == LightColor.green,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  const ModeSwitcher(),
                  SizedBox(height: 10),
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
