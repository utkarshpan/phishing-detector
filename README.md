# phishing_detector

# 🛡️ PhishGuard - AI-Powered Phishing Detector

A powerful Flutter application that protects users from phishing attacks by analyzing URLs, expanding shortened links, validating SSL certificates, and checking domain age.

## 📱 Features

### 🔗 URL Shortener Expander
- Detects shortened URLs (bit.ly, tinyurl, goo.gl, etc.)
- Reveals the real destination URL
- Alerts users about hidden malicious links

### 🔒 SSL Certificate Validation
- Validates SSL certificates for HTTPS websites
- Identifies missing or invalid certificates
- Flags insecure HTTP connections

### 🌐 Domain Age Checker
- Detects newly registered domains (common in phishing)
- Identifies suspicious TLDs (.xyz, .top, .club, etc.)
- Flags risky domain patterns

### 🎯 Advanced Detection
- Typosquatting detection (paypa1 → paypal)
- Suspicious keyword detection (login, verify, secure)
- IP address in URL detection
- Multiple hyphen detection
- @ symbol phishing pattern detection