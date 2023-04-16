import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_clone/features/video/view_models/playback_config_vm.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notification = false;

  void _onNotificationsChange(bool? newValue) {
    if (newValue == null) return;
    setState(() {
      _notification = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            value: context.watch<PlaybackConfigViewModel>().muted,
            onChanged: (value) =>
                context.read<PlaybackConfigViewModel>().setMuted(value),
            title: const Text('Mute video'),
            subtitle: const Text('Video will be muited by default.'),
          ),
          SwitchListTile.adaptive(
            value: context.watch<PlaybackConfigViewModel>().autoplay,
            onChanged: (value) =>
                context.read<PlaybackConfigViewModel>().setAutoplay(value),
            title: const Text('Autoplay'),
            subtitle: const Text('Video will start playing automatically'),
          ),
          CupertinoSwitch(
            value: _notification,
            onChanged: _onNotificationsChange,
          ),
          Switch(
            value: _notification,
            onChanged: _onNotificationsChange,
          ),
          SwitchListTile.adaptive(
            value: _notification,
            onChanged: _onNotificationsChange,
            title: const Text('Enable notifications'),
          ),
          CheckboxListTile(
            value: _notification,
            onChanged: _onNotificationsChange,
            title: const Text('Enable notifications'),
          ),
          ListTile(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime(2030),
              );

              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              final booking = await showDateRangePicker(
                builder: (context, child) {
                  return Theme(
                      data: ThemeData(
                        appBarTheme: const AppBarTheme(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                        ),
                      ),
                      child: child!);
                },
                context: context,
                firstDate: DateTime(1980),
                lastDate: DateTime(2030),
              );
            },
            title: const Text(
              'What is your birthday?',
            ),
          ),
          ListTile(
            onTap: () => showAboutDialog(context: context),
            title: const Text(
              'About',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text('About this app.....'),
          ),
          const AboutListTile(),
          ListTile(
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text(
                    'Are you sure?',
                  ),
                  content: const Text(
                    'Please Don\'t go',
                  ),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('No'),
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
            },
            title: const Text('Log out (iOS)'),
            textColor: Colors.red,
          ),
          ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                    'Are you sure?',
                  ),
                  content: const Text(
                    'Please Don\'t go',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
            },
            title: const Text('Log out (Android)'),
            textColor: Colors.red,
          ),
          ListTile(
            onTap: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) => CupertinoActionSheet(
                  title: const Text(
                    'Are you sure?',
                  ),
                  actions: [
                    CupertinoActionSheetAction(
                      onPressed: () {},
                      child: const Text('Not log out'),
                    ),
                    CupertinoActionSheetAction(
                      isDestructiveAction: true,
                      onPressed: () {},
                      child: const Text('Yes Plz.'),
                    ),
                  ],
                ),
              );
            },
            title: const Text('Log out (iOS / Bottom)'),
            textColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
