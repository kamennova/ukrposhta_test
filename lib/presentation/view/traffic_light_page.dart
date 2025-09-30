import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukrposhtatest/domain/entities/light_color.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_cubit.dart';
import 'package:ukrposhtatest/presentation/cubit/traffic_light_state.dart';

class TrafficLightPage extends StatefulWidget {
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
  late Animation<bool> _animation;

  void _toggleTrafficLight() {
    final cubit = context.read<TrafficLightCubit>();
    if (cubit.state.isPaused) {
      cubit.start();
    } else {
      cubit.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TrafficLightCubit, TrafficLightState>(
      listener: (context, state) {
        log(state.toString());
      },
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<TrafficLightCubit, TrafficLightState>(
          builder: (context, state) {
            return Column(
              children: [
                Flexible(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 20,
                      ),
                      // width: 120,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _Light(
                            color: LightColor.red,
                            isActive: state.currentColor == LightColor.red,
                          ),
                          SizedBox(height: 6),
                          _Light(
                            color: LightColor.yellow,
                            isActive: state.currentColor == LightColor.yellow,
                          ),
                          SizedBox(height: 6),
                          _Light(
                            color: LightColor.green,
                            isActive: state.currentColor == LightColor.green,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MyButton(
                      onPressed: _toggleTrafficLight,
                      icon:
                          state.isPaused
                              ? Icon(Icons.play_arrow)
                              : Icon(Icons.stop),
                      label: state.isPaused ? "Start" : "Stop",
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
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
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        ),
        onPressed: onPressed,
        child: Column(
          children: [
            icon,
            SizedBox(height: 5),
            Text(label, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class _Light extends StatelessWidget {
  final LightColor color;
  final bool isActive;

  const _Light({super.key, required this.isActive, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: isActive ? _colors[color] : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}

const Map<LightColor, Color> _colors = {
  LightColor.red: Colors.red,
  LightColor.yellow: Colors.yellow,
  LightColor.green: Colors.green,
};
