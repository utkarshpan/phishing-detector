import 'scan_result.dart';

class ScanHistory {
  static List<HistoryItem> items = [];

  static void addScan(String url, ScanResult result) {
    items.insert(0, HistoryItem(
      url: url,
      result: result,
      timestamp: DateTime.now(),
    ));
    if (items.length > 50) items.removeLast();
  }

  static void clearHistory() {
    items.clear();
  }
}

class HistoryItem {
  final String url;
  final ScanResult result;
  final DateTime timestamp;

  HistoryItem({
    required this.url,
    required this.result,
    required this.timestamp,
  });

  String get formattedTime {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes} min ago';
    if (diff.inDays < 1) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }
}