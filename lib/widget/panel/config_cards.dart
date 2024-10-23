import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:submission/widget/panel/param_setter.dart';
import 'package:submission/widget/floating_button.dart';


Future<Map<String, dynamic>> _readJson(String path) async {
  final File file = File(path);
  final String jsonString = await file.readAsString();
  return jsonDecode(jsonString) as Map<String, dynamic>;
}


Future<Widget> _getCardContent(String path, String id) async {
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
    list.add(const Divider());
  }
  else if(id == 'train') {
    list.add(const Text(
        'Trainer Config',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
        )
    ));
    list.add(const Divider());
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
        future: _getCardContent(path, 'model'),
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


class TrainingConfigCard extends StatelessWidget {
  const TrainingConfigCard({super.key, required this.path, required this.width});
  final String path;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: FutureBuilder(
        future: _getCardContent(path, 'train'),
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
