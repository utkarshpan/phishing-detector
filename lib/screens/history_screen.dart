import 'package:flutter/material.dart';
import '../models/scan_history.dart';
import 'result_screen.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _filter = 'All';
  String _searchQuery = '';

  List<HistoryItem> get _filteredItems {
    var items = ScanHistory.items;
    if (_filter != 'All') {
      items = items.where((i) => i.result.status == _filter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      items = items.where((i) => i.url.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan History'),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Search History'),
                  content: TextField(
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                    decoration: InputDecoration(hintText: 'Enter URL'),
                    autofocus: true,
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(context), child: Text('Search')),
                  ],
                ),
              );
            },
          ),
          if (ScanHistory.items.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_sweep),
              onPressed: _clearHistory,
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0F2E), Color(0xFF1A1F3E)],
          ),
        ),
        child: Column(
          children: [
            // Filter chips
            Padding(
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'SAFE', 'SUSPICIOUS', 'PHISHING'].map((filter) {
                    return Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: FilterChip(
                        label: Text(filter),
                        selected: _filter == filter,
                        onSelected: (selected) => setState(() => _filter = filter),
                        backgroundColor: Colors.white,
                        selectedColor: _getStatusColor(filter),
                        labelStyle: TextStyle(color: _filter == filter ? Colors.white : Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            // History list
            Expanded(
              child: _filteredItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history, size: 80, color: Colors.grey),
                          SizedBox(height: 20),
                          Text('No scans found', style: TextStyle(fontSize: 18, color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: ListTile(
                            leading: Container(
                              width: 50, height: 50,
                              decoration: BoxDecoration(color: _getStatusColor(item.result.status), shape: BoxShape.circle),
                              child: Icon(_getStatusIcon(item.result.status), color: Colors.white),
                            ),
                            title: Text(item.url, maxLines: 1, overflow: TextOverflow.ellipsis),
                            subtitle: Text('${item.result.status} • Score: ${item.result.score}/100 • ${item.formattedTime}'),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (c) => ResultScreen(scanResult: item.result)),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearHistory() {
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
              setState(() {});
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('History cleared')));
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'SAFE': return Colors.green;
      case 'SUSPICIOUS': return Colors.orange;
      case 'PHISHING': return Colors.red;
      default: return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'SAFE': return Icons.check;
      case 'SUSPICIOUS': return Icons.warning;
      case 'PHISHING': return Icons.dangerous;
      default: return Icons.help;
    }
  }
}