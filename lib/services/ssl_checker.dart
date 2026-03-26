import 'dart:io';

class SslChecker {
  static Future<Map<String, dynamic>> checkSSL(String url) async {
    try {
      // Extract domain from URL
      String domain = url.replaceAll('https://', '').replaceAll('http://', '');
      domain = domain.split('/')[0];
      
      // Remove port if present
      if (domain.contains(':')) {
        domain = domain.split(':')[0];
      }
      
      // Try to connect with SSL
      final socket = await SecureSocket.connect(
        domain,
        443,
        timeout: Duration(seconds: 5),
      );
      
      // If we connected successfully, SSL exists
      socket.destroy();
      
      return {
        'score': -5,  // Good SSL reduces risk
        'message': '✅ Valid SSL certificate (secure connection)',
      };
      
    } on SocketException catch (e) {
      return {
        'score': 30,
        'message': '❌ No SSL certificate found',
      };
    } catch (e) {
      return {
        'score': 20,
        'message': '⚠️ SSL check failed: Could not verify certificate',
      };
    }
  }
}