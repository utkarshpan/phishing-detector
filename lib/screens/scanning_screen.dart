import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/scan_result.dart';

class ScanningScreen extends StatefulWidget {
  final String url;
  ScanningScreen({required this.url});

  @override
  _ScanningScreenState createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
  final ApiService _apiService = ApiService();
  int _currentStep = 0;

  final List<Map<String, dynamic>> _checks = [
    {'title': 'URL Pattern Analysis', 'icon': Icons.analytics, 'completed': false},
    {'title': 'Domain Information', 'icon': Icons.domain, 'completed': false},
    {'title': 'SSL/HTTPS Check', 'icon': Icons.https, 'completed': false},
    {'title': 'Phishing Database Scan', 'icon': Icons.security, 'completed': false},
    {'title': 'Risk Score Calculation', 'icon': Icons.calculate, 'completed': false},
  ];

  @override
  void initState() {
    super.initState();
    _performScan();
  }

  Future<void> _performScan() async {
    for (int i = 0; i < _checks.length; i++) {
      await Future.delayed(Duration(milliseconds: 600));
      if (mounted) {
        setState(() {
          _currentStep = i;
          _checks[i]['completed'] = true;
        });
      }
    }
    ScanResult result = await _apiService.checkUrl(widget.url);
    if (mounted) Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade700, Colors.blue.shade400],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text('Scanning', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                centerTitle: true,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Center(
                          child: SizedBox(
                            width: 60, height: 60,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                              strokeWidth: 4,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                        child: Text(widget.url, style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
                      ),
                      SizedBox(height: 40),
                      LinearProgressIndicator(
                        value: (_currentStep + 1) / _checks.length,
                        backgroundColor: Colors.white30,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 8,
                      ),
                      SizedBox(height: 20),
                      Text(_checks[_currentStep]['title'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 30),
                      ..._checks.asMap().entries.map((entry) {
                        int idx = entry.key;
                        var check = entry.value;
                        bool isCompleted = check['completed'];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Icon(isCompleted ? Icons.check_circle : Icons.radio_button_unchecked, color: Colors.white),
                              SizedBox(width: 12),
                              Text(check['title'], style: TextStyle(color: isCompleted ? Colors.white : Colors.white70)),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}