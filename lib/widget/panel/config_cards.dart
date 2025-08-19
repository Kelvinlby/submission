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


Future<Widget> _getCardContent(String path, String sectionId, ThemeData theme, {Function? setState}) async {
  Map<String, TextEditingController> inputControllers = {};
  Map<String, dynamic> fullData = await _readJson(path);
  dynamic sectionData = fullData[sectionId];

  List<Widget> list = [];

  // Add title with proper formatting
  String title = '${sectionId.substring(0, 1).toUpperCase()}${sectionId.substring(1)} Config';
  list.add(Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
      )
  ));

  list.add(Divider(color: theme.colorScheme.onSecondaryFixed));


  // Handle different data types for section data
  if (sectionData is Map<String, dynamic>) {
    // This is a proper 2-level structure - iterate through 2nd level keys
    for (String paramKey in sectionData.keys) {
      dynamic paramValue = sectionData[paramKey];
      
      // Convert value to string for editing
      String valueStr = _valueToString(paramValue);
      
      TextEditingController controller = TextEditingController(text: valueStr);
      inputControllers[paramKey] = controller;
      
      list.add(const SizedBox(height: 8));
      list.add(ParamSetter(name: paramKey, controller: controller));
    }
  } else {
    // This is a 1-level value - treat the section itself as a single parameter
    String valueStr = _valueToString(sectionData);
    TextEditingController controller = TextEditingController(text: valueStr);
    inputControllers[sectionId] = controller;
    
    list.add(const SizedBox(height: 8));
    list.add(ParamSetter(name: sectionId, controller: controller));
  }

  paramController[sectionId] = inputControllers;

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisSize: MainAxisSize.min, // Important: don't expand unnecessarily
      children: list,
    ),
  );
}

// Helper function to convert any JSON value to string for editing
String _valueToString(dynamic value) {
  if (value == null) {
    return 'null';
  } else if (value is bool) {
    return value.toString();
  } else if (value is num) {
    return value.toString();
  } else if (value is String) {
    return value;
  } else {
    // For complex objects, convert to JSON string
    return jsonEncode(value);
  }
}


class ConfigCard extends StatefulWidget {
  const ConfigCard({super.key, required this.path, required this.sectionId});
  final String path;
  final String sectionId;

  @override
  State<ConfigCard> createState() => _ConfigCardState();
}


class _ConfigCardState extends State<ConfigCard> {
  Widget? cache;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getCardContent(widget.path, widget.sectionId, Theme.of(context), setState: setState),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return cache ?? const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Loading ...'),
            );
          }
          else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Error: ${snapshot.error}'),
            );
          }
          else {
            cache = snapshot.data;
            return snapshot.data!;
          }
        },
    );
  }
}


Future<List<String>> _getConfigSections(String path) async {
  try {
    Map<String, dynamic> data = await _readJson(path);
    
    // Clear the paramController when loading a new config
    // This prevents old sections from persisting
    paramController.clear();
    
    return data.keys.toList();
  } catch (e) {
    // If JSON parsing fails, return empty list
    return [];
  }
}


class DynamicConfigCards extends StatelessWidget {
  const DynamicConfigCards({super.key, required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _getConfigSections(path),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading sections...');
        }
        else if (snapshot.hasError) {
          return Text('Error loading sections: ${snapshot.error}');
        }
        else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No configuration sections found');
        }
        else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: snapshot.data!.map((section) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Card(
                  color: Theme.of(context).colorScheme.onSecondary,
                  child: ConfigCard(
                    path: path,
                    sectionId: section,
                  ),
                ),
              ),
            ).toList(),
          );
        }
      },
    );
  }
}
