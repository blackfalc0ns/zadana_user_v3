import 'dart:convert';

/// Converts Apple Pay payment data into the JSON string expected by Moyasar.
///
/// Depending on the `pay` platform implementation, the token may arrive as
/// either the original JSON string or an already-decoded JSON object.
String? encodeApplePayToken(Object? rawToken) {
  if (rawToken is String) {
    return rawToken.trim().isEmpty ? null : rawToken;
  }

  if (rawToken is Map) {
    try {
      final encoded = jsonEncode(rawToken);
      return encoded == '{}' ? null : encoded;
    } on JsonUnsupportedObjectError {
      return null;
    }
  }

  return null;
}
