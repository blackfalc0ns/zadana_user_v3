import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';

/// Ephemeral, iOS-only support diagnostics. Nothing is persisted or sent.
class SignalRDiagnostics {
  SignalRDiagnostics._();

  static final SignalRDiagnostics instance = SignalRDiagnostics._();
  static const int _maxEntries = 150;

  final ValueNotifier<int> changes = ValueNotifier<int>(0);
  final ListQueue<SignalRDiagnosticEntry> _entries = ListQueue();
  String connectionState = 'Unknown';
  String? connectionId;
  String? currentOrderId;

  List<SignalRDiagnosticEntry> get entries => List.unmodifiable(_entries);
  bool get _enabled => defaultTargetPlatform == TargetPlatform.iOS;

  void connection({required String state, String? id, Object? error}) {
    if (!_enabled) return;
    connectionState = state;
    connectionId = id ?? connectionId;
    add('Notification hub connection', {
      'state': state,
      'connectionId': ?id,
      if (error != null) 'exception': error.toString(),
    });
  }

  void add(String stage, [Map<String, Object?> details = const {}]) {
    if (!_enabled) return;
    _entries.addLast(
      SignalRDiagnosticEntry(DateTime.now(), stage, _sanitize(details)),
    );
    while (_entries.length > _maxEntries) {
      _entries.removeFirst();
    }
    changes.value++;
  }

  void clear() {
    if (!_enabled) return;
    _entries.clear();
    changes.value++;
  }

  String copyableLogs() => const JsonEncoder.withIndent('  ').convert({
    'notificationsConnectionState': connectionState,
    'connectionId': connectionId,
    'currentOrderId': currentOrderId,
    'entries': entries.map((entry) => entry.toJson()).toList(),
  });

  Map<String, Object?> _sanitize(Map<String, Object?> details) =>
      details.map((key, value) => MapEntry(key, _sanitizeValue(key, value)));

  Object? _sanitizeValue(String key, Object? value) {
    final normalized = key.toLowerCase();
    if (normalized.contains('token') || normalized.contains('authorization')) {
      return '<redacted>';
    }
    if (value is String &&
        RegExp(
          r'(token|authorization)\s*[:=]',
          caseSensitive: false,
        ).hasMatch(value)) {
      return '<redacted sensitive text>';
    }
    if (value is Map) {
      return value.map<String, Object?>(
        (key, value) =>
            MapEntry(key.toString(), _sanitizeValue(key.toString(), value)),
      );
    }
    if (value is Iterable) {
      return value.map((item) => _sanitizeValue(key, item)).toList();
    }
    return value;
  }
}

class SignalRDiagnosticEntry {
  const SignalRDiagnosticEntry(this.at, this.stage, this.details);

  final DateTime at;
  final String stage;
  final Map<String, Object?> details;

  Map<String, Object?> toJson() => {
    'at': at.toIso8601String(),
    'stage': stage,
    ...details,
  };
}
