class ScanResult {
  final String status;
  final int score;
  final String reason;
  final Map<String, dynamic>? details;

  ScanResult({
    required this.status,
    required this.score,
    required this.reason,
    this.details,
  });

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      status: json['status'],
      score: json['score'],
      reason: json['reason'],
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'score': score,
      'reason': reason,
      'details': details,
    };
  }
}