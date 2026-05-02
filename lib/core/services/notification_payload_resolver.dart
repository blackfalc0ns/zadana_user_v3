import 'dart:convert';

class NotificationDisplayContent {
  const NotificationDisplayContent({required this.title, this.body});

  final String title;
  final String? body;

  bool get hasVisibleContent =>
      title.trim().isNotEmpty || (body?.trim().isNotEmpty ?? false);
}

class NotificationPayloadResolver {
  const NotificationPayloadResolver._();

  static bool isOrderRelatedType(String? type) {
    final normalizedType = type?.trim().toLowerCase();
    if (normalizedType == null || normalizedType.isEmpty) {
      return false;
    }

    return normalizedType.contains('order') ||
        normalizedType.contains('delivery-otp') ||
        normalizedType.contains('delivery_otp');
  }

  static bool isSupportCaseType(String? type) {
    final normalizedType = type?.trim().toLowerCase();
    if (normalizedType == null || normalizedType.isEmpty) {
      return false;
    }

    return normalizedType.contains('support') ||
        normalizedType.contains('complaint') ||
        normalizedType.contains('return_request') ||
        normalizedType.contains('return-request') ||
        normalizedType.contains('case');
  }

  static Map<String, dynamic> normalize(Map<String, dynamic> rawPayload) {
    final payload = Map<String, dynamic>.from(rawPayload);
    final nestedPayload = _extractNestedPayload(payload);

    if (nestedPayload != null) {
      payload['dataObject'] = nestedPayload;
    }

    for (final key in _stringKeys) {
      payload[key] = _firstNonEmptyString([payload[key], nestedPayload?[key]]);
    }

    payload['referenceId'] = _firstNonEmptyString([
      payload['referenceId'],
      nestedPayload?['referenceId'],
    ]);
    payload['orderId'] = _firstNonEmptyString([
      payload['orderId'],
      nestedPayload?['orderId'],
      payload['order_id'],
      nestedPayload?['order_id'],
    ]);
    payload['caseId'] = _firstNonEmptyString([
      payload['caseId'],
      nestedPayload?['caseId'],
      payload['supportCaseId'],
      nestedPayload?['supportCaseId'],
      payload['case_id'],
      nestedPayload?['case_id'],
      payload['support_case_id'],
      nestedPayload?['support_case_id'],
    ]);
    payload['status'] = _firstNonEmptyString([
      payload['status'],
      nestedPayload?['status'],
      payload['newStatus'],
      nestedPayload?['newStatus'],
      payload['oldStatus'],
      nestedPayload?['oldStatus'],
    ]);

    return payload;
  }

  static NotificationDisplayContent resolveDisplayContent({
    required Map<String, dynamic> payload,
    String? title,
    String? body,
  }) {
    final resolvedTitle = _firstNonEmptyString([
      title,
      payload['title'],
      payload['heading'],
      payload['headings'],
      payload['titleAr'],
      payload['titleEn'],
    ]);
    final resolvedBody = _firstNonEmptyString([
      body,
      payload['body'],
      payload['message'],
      payload['content'],
      payload['contents'],
      payload['bodyAr'],
      payload['bodyEn'],
    ]);

    final displayTitle = resolvedTitle ?? resolvedBody ?? '';
    final displayBody = resolvedTitle == null ? null : resolvedBody;

    return NotificationDisplayContent(title: displayTitle, body: displayBody);
  }

  static String? resolveOrderId(Map<String, dynamic> payload) {
    final normalizedPayload = normalize(payload);
    final targetUrl = normalizedPayload['targetUrl']?.toString();
    final orderIdFromTargetUrl = _extractOrderIdFromTargetUrl(targetUrl);

    final explicitOrderId = _firstNonEmptyString([
      normalizedPayload['orderId'],
      normalizedPayload['order_id'],
      normalizedPayload['dataObject'] is Map
          ? (normalizedPayload['dataObject'] as Map)['orderId']
          : null,
      normalizedPayload['dataObject'] is Map
          ? (normalizedPayload['dataObject'] as Map)['order_id']
          : null,
      orderIdFromTargetUrl,
    ]);
    if (explicitOrderId != null) {
      return explicitOrderId;
    }

    if (isSupportCaseType(normalizedPayload['type']?.toString())) {
      return null;
    }

    return _firstNonEmptyString([normalizedPayload['referenceId']]);
  }

  static String? resolveSupportCaseId(Map<String, dynamic> payload) {
    final normalizedPayload = normalize(payload);
    final targetUrl = normalizedPayload['targetUrl']?.toString();
    final caseIdFromTargetUrl = _extractCaseIdFromTargetUrl(targetUrl);

    final explicitCaseId = _firstNonEmptyString([
      normalizedPayload['caseId'],
      normalizedPayload['supportCaseId'],
      normalizedPayload['case_id'],
      normalizedPayload['support_case_id'],
      normalizedPayload['dataObject'] is Map
          ? (normalizedPayload['dataObject'] as Map)['caseId']
          : null,
      normalizedPayload['dataObject'] is Map
          ? (normalizedPayload['dataObject'] as Map)['supportCaseId']
          : null,
      normalizedPayload['dataObject'] is Map
          ? (normalizedPayload['dataObject'] as Map)['case_id']
          : null,
      normalizedPayload['dataObject'] is Map
          ? (normalizedPayload['dataObject'] as Map)['support_case_id']
          : null,
      caseIdFromTargetUrl,
    ]);
    if (explicitCaseId != null) {
      return explicitCaseId;
    }

    if (isSupportCaseType(normalizedPayload['type']?.toString())) {
      return _firstNonEmptyString([normalizedPayload['referenceId']]);
    }

    return null;
  }

  static String? resolveNotificationId(Map<String, dynamic> payload) {
    final normalizedPayload = normalize(payload);
    return _firstNonEmptyString([
      normalizedPayload['notificationId'],
      normalizedPayload['id'],
    ]);
  }

  static String? resolveStatus(Map<String, dynamic> payload) {
    final normalizedPayload = normalize(payload);
    return _firstNonEmptyString([
      normalizedPayload['status'],
      normalizedPayload['newStatus'],
      normalizedPayload['oldStatus'],
    ]);
  }

  static String resolveDebugSummary(
    Map<String, dynamic> payload, {
    String? title,
    String? body,
  }) {
    final normalizedPayload = normalize(payload);
    final resolvedTitle = _firstNonEmptyString([
      title,
      normalizedPayload['title'],
      normalizedPayload['heading'],
      normalizedPayload['headings'],
      normalizedPayload['titleAr'],
      normalizedPayload['titleEn'],
    ]);
    final resolvedBody = _firstNonEmptyString([
      body,
      normalizedPayload['body'],
      normalizedPayload['message'],
      normalizedPayload['content'],
      normalizedPayload['contents'],
      normalizedPayload['bodyAr'],
      normalizedPayload['bodyEn'],
    ]);
    final keyParts = <String>[
      'type=${normalizedPayload['type'] ?? '-'}',
      'notificationId=${resolveNotificationId(normalizedPayload) ?? '-'}',
      'orderId=${resolveOrderId(normalizedPayload) ?? '-'}',
      'status=${resolveStatus(normalizedPayload) ?? '-'}',
      'title=${resolvedTitle ?? '-'}',
      'bodyExists=${resolvedBody?.isNotEmpty ?? false}',
      'hasHeadings=${_mapValue(normalizedPayload['headings']) != null}',
      'hasContents=${_mapValue(normalizedPayload['contents']) != null}',
      'clickAction=${normalizedPayload['click_action'] ?? '-'}',
      'channel=${_firstNonEmptyString([normalizedPayload['android_channel_id'], normalizedPayload['existing_android_channel_id']]) ?? '-'}',
    ];

    return keyParts.join(', ');
  }

  static Map<String, dynamic>? _extractNestedPayload(
    Map<String, dynamic> payload,
  ) {
    final directDataObject = _mapValue(payload['dataObject']);
    if (directDataObject != null) {
      return directDataObject;
    }

    final directPayload = _mapValue(payload['payload']);
    if (directPayload != null) {
      return directPayload;
    }

    final rawData = payload['data'];
    if (rawData is String && rawData.trim().isNotEmpty) {
      final decodedData = _decodeMap(rawData);
      if (decodedData != null) {
        return decodedData;
      }
    }

    return null;
  }

  static Map<String, dynamic>? _decodeMap(String rawValue) {
    try {
      final decoded = jsonDecode(rawValue);
      return _mapValue(decoded);
    } catch (_) {
      return null;
    }
  }

  static Map<String, dynamic>? _mapValue(dynamic value) {
    if (value is Map<String, dynamic>) {
      return Map<String, dynamic>.from(value);
    }
    if (value is Map) {
      return value.map(
        (key, nestedValue) => MapEntry(key.toString(), nestedValue),
      );
    }
    return null;
  }

  static String? _firstNonEmptyString(Iterable<dynamic> values) {
    for (final value in values) {
      final normalizedValue = _stringValue(value);
      if (normalizedValue != null) {
        return normalizedValue;
      }
    }

    return null;
  }

  static String? _stringValue(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      final trimmedValue = value.trim();
      return trimmedValue.isEmpty ? null : trimmedValue;
    }

    if (value is num || value is bool) {
      return value.toString();
    }

    final mapValue = _mapValue(value);
    if (mapValue != null) {
      return _firstNonEmptyString(mapValue.values);
    }

    return null;
  }

  static const List<String> _stringKeys = <String>[
    'type',
    'id',
    'notificationId',
    'click_action',
    'title',
    'heading',
    'titleAr',
    'titleEn',
    'body',
    'message',
    'content',
    'bodyAr',
    'bodyEn',
    'status',
    'oldStatus',
    'newStatus',
    'orderId',
    'order_id',
    'caseId',
    'case_id',
    'supportCaseId',
    'support_case_id',
    'orderNumber',
    'vendorId',
    'actorRole',
    'action',
    'targetUrl',
    'android_channel_id',
    'existing_android_channel_id',
  ];

  static String? _extractOrderIdFromTargetUrl(String? targetUrl) {
    return _extractPathId(targetUrl, 'orders');
  }

  static String? _extractCaseIdFromTargetUrl(String? targetUrl) {
    return _extractPathId(targetUrl, 'cases');
  }

  static String? _extractPathId(String? targetUrl, String segment) {
    final normalizedUrl = targetUrl?.trim();
    if (normalizedUrl == null || normalizedUrl.isEmpty) {
      return null;
    }

    final match = RegExp(
      '/$segment/([^/?#]+)',
      caseSensitive: false,
    ).firstMatch(normalizedUrl);
    final value = match?.group(1)?.trim();
    return value == null || value.isEmpty ? null : value;
  }
}
