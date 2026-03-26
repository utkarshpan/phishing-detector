import 'package:flutter/material.dart';
import '../models/scan_history.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0F2E), Color(0xFF1A1F3E)],
          ),
        ),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text('Notifications'),
                    subtitle: Text('Get alerts about new threats'),
                    value: _notifications,
                    onChanged: (value) => setState(() => _notifications = value),
                    secondary: Icon(Icons.notifications, color: Colors.blue),
                  ),
                  Divider(),
                  SwitchListTile(
                    title: Text('Dark Mode'),
                    subtitle: Text('Dark theme for night use'),
                    value: _darkMode,
                    onChanged: (value) => setState(() => _darkMode = value),
                    secondary: Icon(Icons.dark_mode, color: Colors.blue),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Clear History'),
                    leading: Icon(Icons.delete_sweep, color: Colors.red),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Clear History'),
                          content: Text('Delete all scan history?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                            TextButton(
                              onPressed: () {
                                ScanHistory.clearHistory();
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('History cleared')));
                              },
                              child: Text('Clear', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Version'),
                    subtitle: Text('1.0.0'),
                    leading: Icon(Icons.info, color: Colors.blue),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('About PhishGuard'),
                    subtitle: Text('AI-powered phishing detection'),
                    leading: Icon(Icons.security, color: Colors.blue),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('About PhishGuard'),
                          content: Text(
                            'PhishGuard v1.0.0\n\n'
                            'AI-powered phishing detection tool that analyzes URLs for:\n'
                            '• Suspicious keywords\n'
                            '• Typosquatting patterns\n'
                            '• SSL/HTTPS status\n'
                            '• Domain anomalies\n\n'
                            'Stay safe online!'
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: Text('OK')),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}