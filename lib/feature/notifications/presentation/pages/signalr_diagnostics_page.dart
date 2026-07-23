import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/feature/notifications/data/services/notifications_signalr_service.dart';
import 'package:zadana_user_v3/feature/notifications/data/services/signalr_diagnostics.dart';

class SignalRDiagnosticsPage extends StatelessWidget {
  const SignalRDiagnosticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final diagnostics = SignalRDiagnostics.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('SignalR Diagnostics')),
      body: ValueListenableBuilder<int>(
        valueListenable: diagnostics.changes,
        builder: (context, _, _) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Notifications connection: ${diagnostics.connectionState}',
                  ),
                  Text(
                    'Connection ID: ${diagnostics.connectionId ?? 'Unavailable'}',
                  ),
                  Text(
                    'Current orderId: ${diagnostics.currentOrderId ?? 'Unavailable'}',
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton(
                        onPressed: () async {
                          await Clipboard.setData(
                            ClipboardData(text: diagnostics.copyableLogs()),
                          );
                        },
                        child: const Text('Copy All Logs'),
                      ),
                      OutlinedButton(
                        onPressed: diagnostics.clear,
                        child: const Text('Clear Logs'),
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          await getIt<NotificationsSignalRService>()
                              .ensureNotificationHubConnection();
                        },
                        child: const Text('Ensure Notification Hub Connection'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: diagnostics.entries.length,
                itemBuilder: (context, index) {
                  final entry = diagnostics.entries.reversed.elementAt(index);
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SelectableText(
                        '${entry.at.toIso8601String()}\n${entry.stage}\n${const JsonEncoder.withIndent('  ').convert(entry.details)}',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
