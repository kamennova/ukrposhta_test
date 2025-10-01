import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukrposhtatest/domain/entities/light_color.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_cubit.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_state.dart';

class TrafficLightPage extends StatefulWidget {
  const TrafficLightPage({super.key});

  @override
  State<StatefulWidget> createState() => _TrafficLightState();
}

class _TrafficLightState extends State<TrafficLightPage> {
  final _lightCubit = TrafficLightCubit();

  @override
  void dispose() {
    _lightCubit.close();
    super.dispose();
  }

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
                            _Light(
                              animation: _animation,
                              color: LightColor.red,
                              isActive:
                                  !isYellow &&
                                  state.currentColor == LightColor.red,
                            ),
                            SizedBox(height: 6),
                            _Light(
                              animation: _animation,
                              color: LightColor.yellow,
                              isActive:
                                  isYellow ||
                                  state.currentColor == LightColor.yellow,
                            ),
                            SizedBox(height: 6),
                            _Light(
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
                  _ModeSwitcher(),
                  SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _MyButton(
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

class _ModeSwitcher extends StatelessWidget {
  Widget _getLabel(TrafficLightMode mode, String label, BuildContext context) {
    return GestureDetector(
      onTap: () {
        final cubit = context.read<TrafficLightCubit>();
        if (cubit.state.mode == mode) return;
        cubit.setMode(mode);
      },
      child: Text(label, style: TextStyle(fontSize: 17)),
    );
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
                value: state.mode == TrafficLightMode.blinkingYellow,
                onChanged:
                    (value) => context.read<TrafficLightCubit>().setMode(
                      value
                          ? TrafficLightMode.blinkingYellow
                          : TrafficLightMode.regular,
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

class _MyButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final Function() onPressed;

  const _MyButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 6,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        ),
        onPressed: onPressed,
        child: Column(
          children: [
            icon,
            SizedBox(height: 5),
            Text(label, style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

class _Light extends StatelessWidget {
  final LightColor color;
  final bool isActive;
  final Animation<double> animation;

  const _Light({
    super.key,
    required this.animation,
    required this.isActive,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 104,
      decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
      child: Center(
        child: FadeTransition(
          opacity: animation,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: isActive ? _colors[color] : null,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

const Map<LightColor, Color> _colors = {
  LightColor.red: Colors.red,
  LightColor.yellow: Colors.yellow,
  LightColor.green: Colors.green,
};
