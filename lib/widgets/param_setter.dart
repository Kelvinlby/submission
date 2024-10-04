import 'package:flutter/material.dart';


class ParamSetter extends StatelessWidget {
  const ParamSetter({super.key, required this.name, required this.controller});
  final String name;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontFamily: 'JetBrains Mono Bold',
            fontSize: 17,
          ),
        ),
        SizedBox(
          width: 128,
          child: TextFormField(
            controller: controller,
            style: const TextStyle(fontFamily: 'JetBrains Mono'),
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }
}
