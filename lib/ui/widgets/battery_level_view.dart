import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

class BatteryLevelView extends StatelessWidget {
  final BatteryState state;
  final int percentage;

  const BatteryLevelView({
    Key? key,
    required this.state,
    required this.percentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var icon = Icons.electric_bolt_rounded;
    if (state == BatteryState.full) {
      icon = Icons.battery_charging_full_rounded;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Battery Level',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: state == BatteryState.charging ||
                            state == BatteryState.full,
                        child: Icon(
                          icon,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      Text(
                        '$percentage %',
                        style: TextStyle(
                          fontSize: 32,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
