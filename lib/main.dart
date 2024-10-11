import 'package:flutter/material.dart';
import 'package:submission/panel.dart';
import 'package:submission/monitor.dart';
import 'package:submission/widgets/floating_button.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Submission',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const HomePage(title: 'Submission'),
    );
  }
}


class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Panel(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Monitor(),
          ),
        ],
      ),
      floatingActionButton: const FloatingButton(),
    );
  }
}
