import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission/widget/panel/config_cards.dart';


class Panel extends StatefulWidget {
  const Panel({super.key});

  @override
  State<Panel> createState() => _PanelState();
}


class _PanelState extends State<Panel> {
  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: _getPanel(Theme.of(context)),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Column(
          children: [
            const Icon(Icons.access_time_outlined),
            const SizedBox(height: 8),
            Text(
              'Loading ...',
              style: TextStyle(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                fontSize: 18,
              ),
            ),
          ],
        );
      }
      else if (snapshot.hasError) {
        return Column(
          children: [
            const Icon(Icons.error_outline),
            const SizedBox(height: 8),
            Text(
              'Error: ${snapshot.error}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                fontSize: 18,
              ),
            ),
          ],
        );
      }
      else {
        return snapshot.data!;
      }
    },
  );


  Future<Widget> _getPanel(ThemeData theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isConda = false;
    String condaNotation = 'Base Conda';
    String? interpreterPath = prefs.getString('Path to Interpreter');
    String? configPath = prefs.getString('Path to Config');
    String? trainerPath = prefs.getString('Path to Trainer');

    if(interpreterPath != null) {
      if(interpreterPath.contains('miniconda')) {
        isConda = true;

        if(interpreterPath.contains('envs')) {
          List<String> segments = interpreterPath.split('/');

          int lastEnvsIndex = -1;
          for (int i = segments.length - 1; i >= 0; i--) {
            if (segments[i] == 'envs') {
              lastEnvsIndex = i;
              break;
            }
          }

          if (lastEnvsIndex != -1 && lastEnvsIndex + 1 < segments.length) {
            condaNotation = 'Conda: ${segments[lastEnvsIndex + 1]}';
          }
        }
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 1),
        SizedBox(
          height: 56,
          child: TextFormField(
            readOnly: true,
            style: const TextStyle(fontFamily: 'JetBrains Mono'),
            initialValue: isConda ? condaNotation : interpreterPath,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Interpreter',
              suffixIcon: IconButton(
                icon: const Icon(Icons.folder_outlined),
                onPressed: () { _pickPath('Path to Interpreter', null, setState); },
              ),
            )
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 56,
          child: TextFormField(
            readOnly: true,
            style: const TextStyle(fontFamily: 'JetBrains Mono'),
            initialValue: configPath,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Config',
              suffixIcon: IconButton(
                icon: const Icon(Icons.folder_outlined),
                onPressed: () { _pickPath('Path to Config', ['json'], setState); },
              ),
            )
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 56,
          child: TextFormField(
            readOnly: true,
            style: const TextStyle(fontFamily: 'JetBrains Mono'),
            initialValue: trainerPath,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Trainer',
              suffixIcon: IconButton(
                icon: const Icon(Icons.folder_outlined),
                onPressed: () { _pickPath('Path to Trainer', ['py', 'python'], setState); },
              ),
            )
          ),
        ),
        const SizedBox(height: 8),
        configPath != null
          ? Expanded(
              child: SingleChildScrollView(
                child: DynamicConfigCards(path: configPath),
              ),
            )
          : const Expanded(child: SizedBox()),
      ],
    );
  }
}


void _pickPath(String id, List<String>? extension, Function setState) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  FilePickerResult? result;

  if(extension != null) {
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extension,
      dialogTitle: id,
    );
  }
  else {
    result = await FilePicker.platform.pickFiles(dialogTitle: id);
  }

  if(result != null) {
    setState(() {
      prefs.setString(id, result!.files.first.path!);
    });
  }
}
