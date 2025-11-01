import 'package:flutter/material.dart';
import 'package:submission/main.dart';
import 'package:submission/widget/floating_button.dart';

class XlaSlider extends StatefulWidget {
  const XlaSlider({super.key});

  @override
  State<XlaSlider> createState() => _XlaSliderState();
}

class _XlaSliderState extends State<XlaSlider> {
  @override
  Widget build(BuildContext context) {
    // Only show if -xla flag is present
    if (!arg.contains('-xla')) {
      return const SizedBox.shrink();
    }

    return Card(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'XLA Memory Allocation',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _getDisplayText(),
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4.0,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                  activeTrackColor: Colors.deepPurple,
                  inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
                  thumbColor: Colors.deepPurple,
                ),
                child: Slider(
                  value: xlaMemoryPercentage,
                  min: 0.0,
                  max: 100.0,
                  divisions: 100,
                  onChanged: (double value) {
                    setState(() {
                      xlaMemoryPercentage = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDisplayText() {
    if (xlaMemoryPercentage == 0.0) {
      return 'On-demand';
    } else if (xlaMemoryPercentage >= 98.0) {
      return 'Auto (${xlaMemoryPercentage.round()}%)';
    } else {
      return '${xlaMemoryPercentage.round()}%';
    }
  }
}