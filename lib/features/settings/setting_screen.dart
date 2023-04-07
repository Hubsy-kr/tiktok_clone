import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
        ],
      ),
    );
  }
}
