import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scan_result.dart';

class ResultScreen extends StatelessWidget {
  final ScanResult scanResult;

  ResultScreen({required this.scanResult});

  Color get _statusColor {
    switch (scanResult.status) {
      case 'SAFE': return Colors.green;
      case 'SUSPICIOUS': return Colors.orange;
      case 'PHISHING': return Colors.red;
      default: return Colors.grey;
    }
  }

  IconData get _statusIcon {
    switch (scanResult.status) {
      case 'SAFE': return Icons.check_circle;
      case 'SUSPICIOUS': return Icons.warning_amber;
      case 'PHISHING': return Icons.dangerous;
      default: return Icons.help;
    }
  }

  String get _statusMessage {
    switch (scanResult.status) {
      case 'SAFE': return 'This website appears to be safe';
      case 'SUSPICIOUS': return 'This website shows suspicious patterns';
      case 'PHISHING': return 'DANGER: This is likely a phishing site!';
      default: return 'Unable to determine';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _statusColor.withOpacity(0.1),
      appBar: AppBar(
        title: Text('Scan Result', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: _statusColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: Column(
                children: [
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(color: _statusColor.withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(_statusIcon, size: 60, color: _statusColor),
                  ),
                  SizedBox(height: 20),
                  Text(scanResult.status, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _statusColor)),
                  SizedBox(height: 10),
                  Text(_statusMessage, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Risk Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: _statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                      child: Text('${scanResult.score}/100', style: TextStyle(color: _statusColor, fontWeight: FontWeight.bold)),
                    ),
                  ]),
                  SizedBox(height: 15),
                  LinearProgressIndicator(
                    value: scanResult.score / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(_statusColor),
                    minHeight: 10,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.analytics, color: _statusColor),
                    SizedBox(width: 10),
                    Text('Analysis Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ]),
                  Divider(height: 25),
                  Text(scanResult.reason, style: TextStyle(height: 1.5)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    child: Text('SCAN AGAIN'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: _statusColor),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    child: Text('NEW SCAN'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: _statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}