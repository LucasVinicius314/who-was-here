import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    return SafeArea(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AppLocalizations.of(context)!.settings,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                child: Text(AppLocalizations.of(context)!.applyChanges),
                onPressed: () async {
                  await Prefs.setHost(_hostController.text);

                  Navigator.of(context).pop(true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
