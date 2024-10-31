import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:submission/interface/process_manager.dart';
import 'package:submission/main.dart';
import 'package:submission/widget/panel/param_setter.dart';
import 'package:submission/widget/floating_button.dart';


Future<Map<String, dynamic>> _readJson(String path) async {
  final File file = File(path);
  final String jsonString = await file.readAsString();
  return jsonDecode(jsonString) as Map<String, dynamic>;
}


Future<Widget> _getCardContent(String path, String id, ThemeData theme, {Function? setState}) async {
  Map<String, TextEditingController> inputControllers = {};
  Map<String, dynamic> data = await _readJson(path);
  data = data[id];

  Iterable<String> params = data.keys;
  List<Widget> list = [];

  if(id == 'model') {
    list.add(const Text(
        'Model Config',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
        )
    ));

    list.add(Divider(color: theme.colorScheme.onSecondaryFixed));
  }
  else if(id == 'train') {
    list.add(const Text(
        'Trainer Config',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
        )
    ));

    list.add(Divider(color: theme.colorScheme.onSecondaryFixed));

    if(arg.contains('-xla')) {
      list.add(     // XLA config option
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'XLA Pre-Allocate',
              style: const TextStyle(
                fontFamily: 'JetBrains Mono Bold',
                fontSize: 17,
              ),
            ),
            Switch(
              value: xlaPreAllocatingStatus,
              activeColor: theme.colorScheme.primary,
              onChanged: (bool value) {
                setState?.call(() {
                  xlaPreAllocatingStatus = value;
                });
              },
            ),
          ],
        )
      );
    }
  }

  for(String param in params) {
    TextEditingController controller = TextEditingController(text: data[param].toString());
    inputControllers[param] = controller;
    list.add(const SizedBox(height: 8));
    list.add(ParamSetter(name: param, controller: controller));
  }

  paramController[id] = inputControllers;

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(children: list),
  );
}


class ModelConfigCard extends StatelessWidget {
  const ModelConfigCard({super.key, required this.path, required this.width});
  final String path;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: FutureBuilder(
        future: _getCardContent(path, 'model', Theme.of(context)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading ...');
          }
          else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          else {
            return snapshot.data!;
          }
        },
      ),
    );
  }
}


class TrainingConfigCard extends StatefulWidget {
  const TrainingConfigCard({super.key, required this.path, required this.width});
  final String path;
  final double width;

  @override
  State<TrainingConfigCard> createState() => _TrainingConfigCardState();
}


class _TrainingConfigCardState extends State<TrainingConfigCard> {
  Widget? cache;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: FutureBuilder(
        future: _getCardContent(widget.path, 'train', Theme.of(context), setState: setState),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return cache ?? const Text('Loading ...');
          }
          else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          else {
            cache = snapshot.data;
            return snapshot.data!;
          }
        },
      ),
    );
  }
}
