class WhoisChecker {
  static Future<Map<String, dynamic>> checkDomainAge(String url) async {
    try {
      // Extract domain
      String domain = url
          .replaceAll('https://', '')
          .replaceAll('http://', '')
          .split('/')[0]
          .split(':')[0];
      
      // Remove www if present
      if (domain.startsWith('www.')) {
        domain = domain.substring(4);
      }
      
      String lowerDomain = domain.toLowerCase();
      
      // ========== CHECK FOR WELL-KNOWN SAFE DOMAINS ==========
      List<String> trustedDomains = [
        'google', 'youtube', 'facebook', 'instagram', 'twitter', 
        'linkedin', 'microsoft', 'apple', 'amazon', 'netflix',
        'github', 'stackoverflow', 'wikipedia', 'yahoo', 'bing'
      ];
      
      for (var trusted in trustedDomains) {
        if (lowerDomain == trusted || lowerDomain == '$trusted.com' || lowerDomain == '$trusted.org') {
          return {
            'score': -15,
            'message': '✅ Established trusted domain (5+ years)',
          };
        }
      }
      
      // ========== CHECK FOR NEW/SUSPICIOUS DOMAIN PATTERNS ==========
      List<String> newDomainPatterns = [
        'xyz', 'top', 'club', 'online', 'site', 'space', 'click',
        'login', 'verify', 'secure', 'account', 'update', 'confirm'
      ];
      
      bool isNewDomain = false;
      for (var pattern in newDomainPatterns) {
        if (lowerDomain.contains(pattern)) {
          isNewDomain = true;
          break;
        }
      }
      
      // ========== CHECK FOR SUSPICIOUS TLDs ==========
      List<String> suspiciousTlds = [
        '.xyz', '.top', '.club', '.online', '.site', '.space', 
        '.click', '.pw', '.info', '.biz', '.cc', '.tk'
      ];
      
      bool hasSuspiciousTld = false;
      for (var tld in suspiciousTlds) {
        if (lowerDomain.contains(tld)) {
          hasSuspiciousTld = true;
          break;
        }
      }
      
      // ========== CHECK FOR RECENT REGISTRATION INDICATORS ==========
      List<String> recentPatterns = [
        '2023', '2024', 'new', 'fresh', 'just', 'today'
      ];
      
      bool isRecentlyRegistered = false;
      for (var pattern in recentPatterns) {
        if (lowerDomain.contains(pattern)) {
          isRecentlyRegistered = true;
          break;
        }
      }
      
      // ========== DETERMINE DOMAIN AGE RISK ==========
      if (isNewDomain || hasSuspiciousTld) {
        return {
          'score': 40,
          'message': '⚠️ Domain appears to be newly registered (high risk)',
        };
      } else if (isRecentlyRegistered) {
        return {
          'score': 25,
          'message': '⚠️ Domain shows signs of recent registration',
        };
      } else if (lowerDomain.length > 30) {
        return {
          'score': 10,
          'message': '⚠️ Unusually long domain name',
        };
      } else {
        return {
          'score': 0,
          'message': '📅 Domain age appears normal',
        };
      }
      
    } catch (e) {
      return {
        'score': 0,
        'message': '⚠️ Could not determine domain age',
      };
    }
  }
}