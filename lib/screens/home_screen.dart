import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../models/scan_result.dart';
import '../models/scan_history.dart';
import 'scanning_screen.dart';
import 'result_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _urlController = TextEditingController();
  final ApiService _apiService = ApiService();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Track stats to trigger rebuild
  int _totalScans = 0;
  int _threatCount = 0;
  int _safeCount = 0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_fadeController);
    _fadeController.forward();
    _updateStats();
  }

  void _updateStats() {
    setState(() {
      _totalScans = ScanHistory.items.length;
      _threatCount = ScanHistory.items.where((h) => h.result.status == 'PHISHING').length;
      _safeCount = ScanHistory.items.where((h) => h.result.status == 'SAFE').length;
    });
  }

  Future<void> _scanUrl() async {
    String url = _urlController.text.trim();
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a URL'), backgroundColor: Colors.orange),
      );
      return;
    }

    if (!url.startsWith('http')) url = 'https://$url';

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScanningScreen(url: url)),
    );

    if (result != null && mounted) {
      ScanHistory.addScan(url, result);
      _updateStats(); // Update stats after adding scan
      
      // Force refresh to show updated stats
      setState(() {});
      
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultScreen(scanResult: result)),
      );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0F2E), Color(0xFF1A1F3E)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PhishGuard', style: GoogleFonts.poppins(
                            fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white,
                          )),
                          Text('AI-Powered Protection', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.history, color: Colors.white),
                            onPressed: () async {
                              await Navigator.push(context, MaterialPageRoute(builder: (c) => HistoryScreen()));
                              _updateStats(); // Update stats when returning from history
                              setState(() {});
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.settings, color: Colors.white),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (c) => SettingsScreen()));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Security Score Card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Colors.blue.shade600, Colors.purple.shade600]),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 20, offset: Offset(0, 10))],
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.shield, size: 60, color: Colors.white),
                              SizedBox(height: 10),
                              Text('Your Security Score', style: TextStyle(color: Colors.white70, fontSize: 18)),
                              Text('100%', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                              Text('Protected', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        // URL Input Card
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Scan Website', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              SizedBox(height: 20),
                              TextField(
                                controller: _urlController,
                                decoration: InputDecoration(
                                  hintText: 'Enter URL (e.g., example.com)',
                                  prefixIcon: Icon(Icons.link, color: Colors.blue),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.go,
                                onSubmitted: (_) => _scanUrl(),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _scanUrl,
                                child: Text('SCAN WEBSITE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 55),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  backgroundColor: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        // Security Tips
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Icon(Icons.tips_and_updates, color: Colors.blue),
                                SizedBox(width: 10),
                                Text('Security Tips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ]),
                              SizedBox(height: 15),
                              _buildTip('🔒 Always check for HTTPS', 'Look for the padlock icon'),
                              _buildTip('⚠️ Watch for misspellings', 'Phishers use amaz0n.com'),
                              _buildTip('📧 Never click suspicious links', 'Especially in emails'),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        // Stats Card
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStat(Icons.security, '$_totalScans', 'Scans', Colors.green),
                              Container(height: 40, width: 1, color: Colors.grey.shade300),
                              _buildStat(Icons.warning, '$_threatCount', 'Threats', Colors.red),
                              Container(height: 40, width: 1, color: Colors.grey.shade300),
                              _buildStat(Icons.check_circle, '$_safeCount', 'Safe', Colors.green),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTip(String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        SizedBox(height: 5),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }
}