import 'package:flutter/material.dart';


class NumberTitle extends StatefulWidget {
  const NumberTitle({super.key, required this.title, required this.total, required this.used});
  final String title;
  final String total;
  final String used;

  @override
  State<NumberTitle> createState() => _NumberTitleState();
}

class _NumberTitleState extends State<NumberTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8,
          left: 12,
          right: 12,
          bottom: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                widget.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                )
            ),
            Row(
              children: [
                Text(
                  widget.used,
                  style: TextStyle(fontFamily: 'JetBrains Mono'),
                ),
                const SizedBox(width: 4),
                const Text(
                  '/',
                  style: TextStyle(fontFamily: 'JetBrains Mono', color: Colors.grey),
                ),
                const SizedBox(width: 4),
                Text(
                  widget.total,
                  style: TextStyle(fontFamily: 'JetBrains Mono'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


class PercentTitle extends StatefulWidget {
  const PercentTitle({super.key, required this.title, required this.percent});
  final String title;
  final String percent;

  @override
  State<PercentTitle> createState() => _PercentTitleState();
}

class _PercentTitleState extends State<PercentTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8,
          left: 12,
          right: 12,
          bottom: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            Row(
              children: [
                Text(
                  widget.percent,
                  style: TextStyle(fontFamily: 'JetBrains Mono'),
                ),
                const SizedBox(width: 4),
                const Text(
                  '%',
                  style: TextStyle(fontFamily: 'JetBrains Mono', color: Colors.grey),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


class ValueTitle extends StatefulWidget {
  const ValueTitle({super.key, required this.title, required this.value});
  final String title;
  final String value;

  @override
  State<ValueTitle> createState() => _ValueTitleState();
}

class _ValueTitleState extends State<ValueTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8,
          left: 16,
          right: 16,
          bottom: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              children: [
                const Text(
                  'Latest:',
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 16,
                    color: Colors.grey
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  widget.value,
                  style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 16,
                  ),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}
