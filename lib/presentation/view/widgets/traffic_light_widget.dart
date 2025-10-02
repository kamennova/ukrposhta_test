import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukrposhtatest/presentation/view/widgets/single_light_widget.dart';

import '../../../domain/entities/light_color.dart';
import '../../cubit/traffic_light_cubit.dart';
import '../../cubit/traffic_light_state.dart';

class TrafficLightWidget extends StatefulWidget {
  const TrafficLightWidget({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TrafficLightWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

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
      child: BlocBuilder<TrafficLightCubit, TrafficLightState>(
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              spacing: 6,
              mainAxisSize: MainAxisSize.min,
              children:
                  [LightColor.red, LightColor.yellow, LightColor.green]
                      .map(
                        (color) => TrafficLightCircle(
                          animation: _animation,
                          color: color,
                          isActive: state.currentColor == color,
                        ),
                      )
                      .toList(),
            ),
          );
        },
      ),
    );
  }
}
