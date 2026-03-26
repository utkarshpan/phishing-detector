import '../models/scan_result.dart';
import 'url_expander.dart';
import 'ssl_checker.dart';
import 'whois_checker.dart';

class ApiService {
  Future<ScanResult> checkUrl(String url) async {
    await Future.delayed(Duration(milliseconds: 500));
    return await _analyzeUrl(url);
  }

  Future<ScanResult> _analyzeUrl(String url) async {
    int score = 0;
    List<String> reasons = [];
    String originalUrl = url;
    String lowerUrl = url.toLowerCase();

    // ========== FEATURE 1: URL SHORTENER EXPANDER ==========
    if (UrlExpander.isShortenedUrl(url)) {
      String shortener = UrlExpander.getShortenerName(url);
      reasons.add('⚠️ URL shortener detected: $shortener');
      score += 15;
      
      String? expandedUrl = await UrlExpander.expandUrl(url);
      if (expandedUrl != null && expandedUrl != url) {
        reasons.add('📎 Expands to: ${_truncateUrl(expandedUrl)}');
        url = expandedUrl;
        lowerUrl = url.toLowerCase();
      }
    }

    // ========== FEATURE 2: SSL CERTIFICATE VALIDATION ==========
    if (url.startsWith('https://')) {
      try {
        final sslInfo = await SslChecker.checkSSL(url);
        int sslScore = sslInfo['score'] as int;
        score += sslScore;
        reasons.add(sslInfo['message'] as String);
      } catch (e) {
        reasons.add('⚠️ SSL check failed');
        score += 10;
      }
    } else {
      score += 20;
      reasons.add('❌ No HTTPS/SSL encryption (insecure connection)');
    }

    // ========== FEATURE 3: DOMAIN AGE CHECKER ==========
    try {
      final domainInfo = await WhoisChecker.checkDomainAge(url);
      int domainScore = domainInfo['score'] as int;
      score += domainScore;
      reasons.add(domainInfo['message'] as String);
    } catch (e) {
      reasons.add('⚠️ Could not check domain age');
      score += 5;
    }

    // ========== BASIC DETECTION ==========
    
    // Suspicious keywords
    List<String> keywords = ['login', 'verify', 'secure', 'account', 'update', 'confirm', 'signin', 'banking'];
    for (var kw in keywords) {
      if (lowerUrl.contains(kw)) {
        score += 20;
        reasons.add('⚠️ Suspicious keyword: $kw');
        break;
      }
    }

    // Typosquatting
    Map<String, String> typos = {
      'paypa1': 'paypal', 'amaz0n': 'amazon', 'g00gle': 'google',
      'faceb00k': 'facebook', 'micros0ft': 'microsoft', 'twitt3r': 'twitter'
    };
    for (var entry in typos.entries) {
      if (lowerUrl.contains(entry.key)) {
        score += 50;
        reasons.add('🚨 Typosquatting: ${entry.key} instead of ${entry.value}');
        break;
      }
    }

    // IP address detection
    if (RegExp(r'\d+\.\d+\.\d+\.\d+').hasMatch(url)) {
      score += 50;
      reasons.add('🚨 Uses IP address instead of domain name');
    }

    // Multiple hyphens
    int hyphenCount = (url.split('-').length - 1);
    if (hyphenCount > 2) {
      score += 15;
      reasons.add('⚠️ Multiple hyphens ($hyphenCount) - possible fake domain');
    }

    // @ symbol
    if (url.contains('@')) {
      score += 40;
      reasons.add('🚨 Contains @ symbol (phishing pattern)');
    }

    // Suspicious TLDs
    List<String> riskyTLDs = ['.xyz', '.top', '.club', '.online', '.site', '.space', '.click'];
    for (var tld in riskyTLDs) {
      if (lowerUrl.contains(tld)) {
        score += 15;
        reasons.add('⚠️ Risky top-level domain ($tld)');
        break;
      }
    }

    // Final score clamp
    score = score.clamp(0, 100);
    
    // Determine status
    String status;
    if (score >= 70) {
      status = 'PHISHING';
    } else if (score >= 30) {
      status = 'SUSPICIOUS';
    } else {
      status = 'SAFE';
    }

    // Build result message
    reasons.insert(0, '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    reasons.insert(1, '📊 RISK ANALYSIS SUMMARY');
    reasons.insert(2, '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    reasons.insert(3, '');
    reasons.insert(4, '🎯 Final Risk Score: ${score}/100');
    reasons.insert(5, '📋 Status: $status');
    reasons.insert(6, '');
    
    // Prepare details map
    Map<String, dynamic> details = {
      'original_url': originalUrl,
      'risk_score': score,
      'risk_level': status,
    };
    
    if (url != originalUrl) {
      details['expanded_url'] = url;
    }

    return ScanResult(
      status: status,
      score: score,
      reason: reasons.join('\n'),
      details: details,
    );
  }

  String _truncateUrl(String url, {int maxLength = 80}) {
    if (url.length <= maxLength) return url;
    return '${url.substring(0, maxLength)}...';
  }
}