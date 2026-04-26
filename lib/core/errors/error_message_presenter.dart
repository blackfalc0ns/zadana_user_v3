import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/errors/api_error_type.dart';
import 'package:zadana_user_v3/core/errors/api_exception.dart';
import 'package:zadana_user_v3/core/network/failuer_mapper.dart';

class ErrorMessagePresenter {
  const ErrorMessagePresenter._();

  static String snackBarMessage(
    BuildContext context,
    ApiException exception,
  ) {
    return userFacingMessage(context, exception);
  }

  static String userFacingMessage(
    BuildContext context,
    ApiException exception,
  ) {
    final backendMessage = tryGetUserFacingBackendMessage(exception);
    if (backendMessage != null) {
      return backendMessage;
    }

    return mapFailureMessage(context, exception.errorType.translationKey);
  }

  static String? tryGetUserFacingBackendMessage(ApiException exception) {
    if (exception.isTranslationKey) return null;
    return sanitizeBackendMessage(exception.message);
  }

  static String? sanitizeBackendMessage(String? message) {
    if (message == null) return null;

    final trimmed = message.trim();
    if (trimmed.isEmpty) return null;
    if (_looksTechnical(trimmed)) return null;

    return trimmed;
  }

  static bool hasUserFacingBackendMessage(ApiException exception) {
    return tryGetUserFacingBackendMessage(exception) != null;
  }

  static bool _looksTechnical(String message) {
    final lower = message.toLowerCase();

    const technicalFragments = <String>[
      'sql',
      'mysql',
      'postgres',
      'sqlite',
      'database',
      'query',
      'exception',
      'stack trace',
      'trace:',
      'nullreference',
      'typeerror',
      'syntaxerror',
      'laravel',
      'eloquent',
      'sqlstate',
      'pdo',
      'select ',
      'insert ',
      'update ',
      'delete ',
      ' from ',
      ' where ',
      '.php',
      '.dart',
      '.kt',
      '.java',
      '.cs',
      '.swift',
      '/var/',
      '/usr/',
      'c:\\',
      'd:\\',
      'stacktrace',
    ];

    if (technicalFragments.any(lower.contains)) {
      return true;
    }

    final pathPattern = RegExp(r'([a-zA-Z]:\\|/).+');
    final stackLinePattern = RegExp(r'^\s*#?\d+\s+', multiLine: true);
    final sqlKeywordPattern = RegExp(
      r'\b(select|insert|update|delete|from|where|join)\b',
    );

    return pathPattern.hasMatch(message) ||
        stackLinePattern.hasMatch(message) ||
        sqlKeywordPattern.hasMatch(lower);
  }
}
