//import 'package:chat_app/home/page/home_page.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/settings/widget/settings_section_widget.dart';
import 'package:chat_app/settings/widget/settings_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  
  bool notificationEnabled = true;
  bool readReceipts = true;
  String selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationEnabled = prefs.getBool('notificationEnabled') ?? true;
    });

  }

  void toggleNotification(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationEnabled', value);
    setState(() {
      notificationEnabled = value;
    });
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        value ? 'Notifications Enabled' : 'Notifications Disabled',
      ),
      duration: const Duration(seconds: 1),
    ),
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings"),),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SettingsSectionWidget(
            
            title: "General", 
            tiles: [
              ValueListenableBuilder(
                valueListenable: isDarkMode,
                builder: (context, value, child) {
                  return SwitchListTile(
                    title: const Text("Dark Mode"),
                    value: value,
                    onChanged: (val) {
                      setState(() => isDarkMode.value = val);
                    },
                  );
                }
              ),
              ListTile(
                title: const Text("App Language"),
                trailing: DropdownButton<String>(
                  value: selectedLanguage,
                  items: ['English', 'Nepali', 'Hindi'].map((lang) {
                    return DropdownMenuItem(value: lang, child: Text(lang));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedLanguage = value!);
                  },
                ),
              ),

            ],
          ),
          
          const SizedBox(height: 16),
          SettingsSectionWidget(
            title: 'Chats',
            tiles: [
              SettingsTileWidget(title: 'Theme', onTap: () {},),
              
            ],
          ),
          const SizedBox(height: 16),
          SettingsSectionWidget(
            title: "Notifications",
            tiles: [
              SwitchListTile(
                title: const Text("Message Notifications"),
                value: notificationEnabled,
                onChanged: toggleNotification
              ),
            ],
          ),
          const SizedBox(height: 16,),
          SettingsSectionWidget(
            title: "Help", 
            tiles: [
              SettingsTileWidget(title: "App info", onTap: () {},)
            ])

        ],
      ),
    );
  }
}