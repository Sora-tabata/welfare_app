import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  bool notificationsEnabled = false;
  bool darkModeEnabled = false; // ダークモードの設定用変数
  bool soundEnabled = true; // サウンドの設定用変数
  String language = '日本語';  // 初期言語設定
  String appVersion = '1.0.0'; // アプリのバージョン

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: '一般設定',  // 一般設定
          tiles: [
            SettingsTile.switchTile(
              title: '通知設定',  // 通知設定
              leading: Icon(Icons.notifications_none),
              switchValue: notificationsEnabled,
              onToggle: (bool newValue) {
                setState(() {
                  notificationsEnabled = newValue;
                });
              },
            ),
            SettingsTile.switchTile(
              title: 'サウンド設定',  // サウンド設定
              leading: Icon(Icons.music_note),
              switchValue: soundEnabled,
              onToggle: (bool newValue) {
                setState(() {
                  soundEnabled = newValue;
                });
              },
            ),
            SettingsTile.switchTile(
              title: 'ダークモード設定',  // ダークモード設定
              leading: Icon(Icons.brightness_4),
              switchValue: darkModeEnabled,
              onToggle: (bool newValue) {
                setState(() {
                  darkModeEnabled = newValue;
                });
              },
            ),
            SettingsTile(
              title: '言語設定',  // 言語設定
              subtitle: language,
              leading: Icon(Icons.language),
              onPressed: (BuildContext context) {
                // 言語選択画面を開く等のアクションを実装
              },
            ),
            // 他の一般設定項目をここに追加できます。
          ],
        ),
        SettingsSection(
          title: 'アカウント',  // アカウント設定
          tiles: [
            SettingsTile(
              title: 'アカウント設定', // アカウント設定画面へのリンク
              leading: Icon(Icons.person),
              onPressed: (BuildContext context) {
                // アカウント設定ページを開く等のアクションを実装
              },
            ),
          ],
        ),
        SettingsSection(
          title: 'セキュリティ・プライバシー',  // セキュリティ設定
          tiles: [
            SettingsTile(
              title: 'パスワード変更', // パスワード変更
              leading: Icon(Icons.lock),
              onPressed: (BuildContext context) {
                // パスワード変更画面を開く等のアクションを実装
              },
            ),
          ],
        ),
        SettingsSection(
          title: 'アプリケーション',  // アプリケーション設定
          tiles: [
            SettingsTile(
              title: 'このアプリについて',  // このアプリについて
              subtitle: 'バージョン $appVersion', // バージョン情報
              leading: Icon(Icons.info_outline),
              onPressed: (BuildContext context) {
                // アプリ情報ページを開く等のアクションを実装
              },
            ),
          ],
        ),
        CustomSection(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 22, bottom: 8),
                child: Text(
                  '© 2023 株式会社与和s All rights reserved.',  // コピーライト表記
                  style: TextStyle(color: Color(0xFF777777)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
