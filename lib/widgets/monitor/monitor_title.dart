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
    return Padding(
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
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w800,
            )
          ),
          Row(
            children: [
              Text(
                widget.used,
                style: TextStyle(fontFamily: 'JetBrains Mono'),
              ),
              SizedBox(width: 4),
              Text(
                '/',
                style: TextStyle(fontFamily: 'JetBrains Mono', color: Colors.grey),
              ),
              SizedBox(width: 4),
              Text(
                widget.total,
                style: TextStyle(fontFamily: 'JetBrains Mono'),
              ),
            ],
          )
        ],
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
    return Padding(
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
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w800,
              ),
          ),
          Row(
            children: [
              Text(
                widget.percent,
                style: TextStyle(fontFamily: 'JetBrains Mono'),
              ),
              SizedBox(width: 4),
              Text(
                '%',
                style: TextStyle(fontFamily: 'JetBrains Mono', color: Colors.grey),
              ),
            ],
          )
        ],
      ),
    );
  }
}
