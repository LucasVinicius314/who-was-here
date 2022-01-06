import 'package:flutter/material.dart';
import 'package:who_was_here/utils/services/shared_preferences.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final _hostController = TextEditingController();
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final host = await Prefs.host;

      _hostController.text = host;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Settings',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextFormField(
            controller: _hostController,
            decoration: const InputDecoration(
              labelText: 'Host',
              alignLabelWithHint: true,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextButton(
            child: const Text('Apply changes'),
            onPressed: () async {
              await Prefs.setHost(_hostController.text);

              Navigator.of(context).pop(true);
            },
          ),
        ),
      ],
    );
  }
}
