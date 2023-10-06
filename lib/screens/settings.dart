import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';  // 必要なパッケージをインポート
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
class SettingsPage extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: 'Section',
          tiles: [
            SettingsTile(
              title: 'Language',
              subtitle: 'English',
              leading: Icon(Icons.language),
              onPressed: (BuildContext context) {},
            ),
            SettingsTile.switchTile(
              title: 'Use fingerprint',
              leading: Icon(Icons.fingerprint),
              switchValue: value,
              onToggle: (bool newValue) {
                setState(() {
                  value = newValue;
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
