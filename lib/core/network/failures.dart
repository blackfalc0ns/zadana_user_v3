import 'package:dio/dio.dart';

class Failure {
  const Failure({required this.errorMessage, this.code = 'unknown'});
  final String errorMessage;
  final String code;
}

class ServerFailure extends Failure {
  const ServerFailure({required super.errorMessage, super.code});

  factory ServerFailure.fromDioError({required DioException dioException}) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return const ServerFailure(
          errorMessage: 'Connection timeout with API server.',
          code: 'error_connection_timeout',
        );

      case DioExceptionType.sendTimeout:
        return const ServerFailure(
          errorMessage: 'Send timeout with API server.',
          code: 'error_send_timeout',
        );

      case DioExceptionType.receiveTimeout:
        return const ServerFailure(
          errorMessage: 'Receive timeout with API server.',
          code: 'error_receive_timeout',
        );

      case DioExceptionType.badCertificate:
        return const ServerFailure(
          errorMessage: 'Connection failed because of an invalid certificate.',
          code: 'error_bad_certificate',
        );

      case DioExceptionType.cancel:
        return const ServerFailure(
          errorMessage: 'Request to API server was cancelled.',
          code: 'error_request_cancelled',
        );

      case DioExceptionType.connectionError:
        return const ServerFailure(
          errorMessage: 'No internet connection.',
          code: 'error_no_internet',
        );

      case DioExceptionType.unknown:
        return const ServerFailure(
          errorMessage: 'Unexpected error occurred. Please try again later.',
          code: 'error_unknown',
        );

      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(dioException.response);
    }
  }

  factory ServerFailure.fromResponse(Response? response) {
    if (response == null) {
      return const ServerFailure(
        errorMessage: 'No response received from server.',
        code: 'error_no_response',
      );
    }

    final statusCode = response.statusCode;
    final data = response.data;
    final message = _extractMessage(data);

    switch (statusCode) {
      case 400:
        return ServerFailure(
          errorMessage: message ?? 'Bad request.',
          code: 'error_bad_request',
        );

      case 401:
        return ServerFailure(
          errorMessage: message ?? 'Unauthorized.',
          code: 'error_unauthorized',
        );

      case 403:
        return ServerFailure(
          errorMessage: message ?? 'Forbidden.',
          code: 'error_forbidden',
        );

      case 404:
        return ServerFailure(
          errorMessage: message ?? 'Resource not found.',
          code: 'error_not_found',
        );

      case 409:
        return ServerFailure(
          errorMessage: message ?? 'Conflict occurred.',
          code: 'error_conflict',
        );

      case 422:
        return ServerFailure(
          errorMessage: message ?? 'Validation error.',
          code: 'error_validation',
        );

      case 500:
        return ServerFailure(
          errorMessage: message ?? 'Server error. Please try again later.',
          code: 'error_server',
        );

      default:
        return ServerFailure(
          errorMessage: message ?? 'Unexpected server error.',
          code: _extractCode(data) ?? 'error_unknown',
        );
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map) {
      final detail = data['detail'];
      final message = data['message'];
      final error = data['error'];
      final title = data['title'];

      if (detail is String && detail.trim().isNotEmpty) return detail;
      if (message is String && message.trim().isNotEmpty) return message;
      if (error is String && error.trim().isNotEmpty) return error;
      if (title is String && title.trim().isNotEmpty) return title;
    }

    if (data is String && data.trim().isNotEmpty) {
      return data;
    }

    return null;
  }

  static String? _extractCode(dynamic data) {
    if (data is Map) {
      final code = data['code'];
      if (code is String && code.trim().isNotEmpty) return code;
      if (code != null) return code.toString();
    }

    return null;
  }
}
