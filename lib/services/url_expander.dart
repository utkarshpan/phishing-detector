import 'package:dio/dio.dart';

class UrlExpander {
  static final Dio _dio = Dio();

  // List of known URL shorteners
  static final List<String> _shorteners = [
    'bit.ly', 'tinyurl.com', 'goo.gl', 'ow.ly', 'is.gd', 
    'buff.ly', 'shorturl.at', 'rb.gy', 'cutt.ly', 'tiny.cc',
    'shorte.st', 'adf.ly', 'bc.vc', 's.id', 'lnkd.in',
    'rebrand.ly', 'clicky.me', 'v.gd', 'tiny.one', 'urlzs.com'
  ];

  // Check if URL is shortened
  static bool isShortenedUrl(String url) {
    String lowerUrl = url.toLowerCase();
    for (var shortener in _shorteners) {
      if (lowerUrl.contains(shortener)) {
        return true;
      }
    }
    return false;
  }

  // Expand the shortened URL
  static Future<String?> expandUrl(String url) async {
    try {
      final response = await _dio.head(
        url,
        options: Options(
          followRedirects: true,
          maxRedirects: 10,
          validateStatus: (status) => status! < 400,
        ),
      );
      
      final expandedUrl = response.realUri.toString();
      
      if (expandedUrl != url) {
        return expandedUrl;
      }
      return null;
    } catch (e) {
      print('Error expanding URL: $e');
      return null;
    }
  }

  // Get the shortener service name
  static String getShortenerName(String url) {
    String lowerUrl = url.toLowerCase();
    for (var shortener in _shorteners) {
      if (lowerUrl.contains(shortener)) {
        return shortener;
      }
    }
    return 'Unknown';
  }
}