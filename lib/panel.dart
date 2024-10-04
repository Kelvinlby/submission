import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission/widgets/config_cards.dart';


Widget panel(Function setState, Color color) {
  return FutureBuilder(
    future: _getPanel(setState, color),
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
  );
}


Future<Widget> _getPanel(Function setState, Color color) async {
  const int overflowLength = 23;
  const double width = 320.0;
  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool isConda = false, interpreterPathEllipsis = false, configPathEllipsis = false, trainerPathEllipsis = false;
  String? interpreterPath = prefs.getString('Path to Interpreter');
  String? configPath = prefs.getString('Path to Config');
  String? trainerPath = prefs.getString('Path to Trainer');

  if(interpreterPath != null) {
    if(interpreterPath.contains('miniconda')) {
      isConda = true;
    }
    else if(interpreterPath.length >= overflowLength) {
      interpreterPathEllipsis = true;
    }
  }

  if(configPath != null) {
    if(configPath.length >= overflowLength) {
      configPathEllipsis = true;
    }
  }

  if(trainerPath != null) {
    if(trainerPath.length >= overflowLength) {
      trainerPathEllipsis = true;
    }
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      const SizedBox(height: 1),
      SizedBox(
        width: width,
        height: 56,
        child: TextFormField(
          readOnly: true,
          style: const TextStyle(fontFamily: 'JetBrains Mono'),
          initialValue: isConda
              ? 'miniconda'
              : interpreterPathEllipsis
                ? interpreterPath!.substring(interpreterPath.length - overflowLength)
                : interpreterPath,
          decoration: isConda
              ? InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Interpreter',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.folder_outlined),
                    onPressed: () { _pickPath('Path to Interpreter', '', setState); },
                  ),
                )
              : interpreterPathEllipsis
                  ? InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Interpreter',
                      prefix: const Text('...', style: TextStyle(color: Colors.grey)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.folder_outlined),
                        onPressed: () { _pickPath('Path to Interpreter', '', setState); },
                      ),
                    )
                  : InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Interpreter',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.folder_outlined),
                        onPressed: () { _pickPath('Path to Interpreter', '', setState); },
                      ),
                    )
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        width: width,
        height: 56,
        child: TextFormField(
          readOnly: true,
          style: const TextStyle(fontFamily: 'JetBrains Mono'),
          initialValue: configPathEllipsis ? configPath!.substring(configPath.length - overflowLength) : configPath,
          decoration: configPathEllipsis
              ? InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Config',
                  prefix: const Text('...', style: TextStyle(color: Colors.grey)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.folder_outlined),
                    onPressed: () { _pickPath('Path to Config', 'json', setState); },
                  ),
                )
              : InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Config',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.folder_outlined),
                    onPressed: () { _pickPath('Path to Config', 'json', setState); },
                  ),
                )
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        width: width,
        height: 56,
        child: TextFormField(
          readOnly: true,
          style: const TextStyle(fontFamily: 'JetBrains Mono'),
          initialValue: trainerPathEllipsis ? trainerPath!.substring(trainerPath.length - overflowLength) : trainerPath,
          decoration: trainerPathEllipsis
              ? InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Trainer',
                  prefix: const Text('...', style: TextStyle(color: Colors.grey)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.folder_outlined),
                    onPressed: () { _pickPath('Path to Trainer', 'py', setState); },
                  ),
                )
              : InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Trainer',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.folder_outlined),
                    onPressed: () { _pickPath('Path to Trainer', 'py', setState); },
                  ),
                )
        ),
      ),
      const SizedBox(height: 8),
      configPath != null
          ? Card.filled(color: color, child: ModelConfigCard(path: configPath, width: width))
          : const SizedBox(height: 0),
      configPath != null
          ? Card.filled(color: color, child: TrainingConfigCard(path: configPath, width: width))
          : const SizedBox(height: 0),
    ],
  );
}


void _pickPath(String id, String extension, Function setState) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: [extension],
    dialogTitle: id
  );

  if(result != null) {
    prefs.setString(id, result.files.first.path!);
    setState(() {});
  }
}
