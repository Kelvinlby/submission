import 'package:flutter/material.dart';


class JobInfoCard extends StatefulWidget {
  const JobInfoCard({super.key, required this.name, required this.percent});
  final String name;
  final double? percent;    // setting to `null` will show a indeterminate progress indicator

  @override
  State<JobInfoCard> createState() => _JobInfoCardState();
}


class _JobInfoCardState extends State<JobInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        widget.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'JetBrains Mono Bold'
                        ),
                    ),
                    Row(
                      children: [
                        widget.percent == null
                            ? const SizedBox.shrink()
                            : Text(
                                (widget.percent! * 100).toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'JetBrains Mono'
                                ),
                              ),
                        const SizedBox(width: 4),
                        widget.percent == null
                            ? const SizedBox.shrink()
                            : const Text(
                                '%',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'JetBrains Mono Bold',
                                  color: Colors.grey
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: widget.percent),
              ],
            ),
          ),
        )
    );
  }
}