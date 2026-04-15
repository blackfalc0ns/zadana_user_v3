import 'package:flutter/material.dart';
import 'package:zadana_user_v3/core/errors/api_error_type.dart';
import 'package:zadana_user_v3/core/errors/api_exception.dart';
import 'package:zadana_user_v3/core/network/failures.dart';

import 'client_error_widget.dart';
import 'generic_error_widget.dart';
import 'no_internet_error_widget.dart';
import 'server_error_widget.dart';
import 'timeout_error_widget.dart';

class ApiErrorWidget extends StatelessWidget {
  const ApiErrorWidget({
    super.key,
    required this.exception,
    this.onRetry,
    this.onGoBack,
    this.onContactSupport,
    this.onCheckConnection,
  });
  final ApiException exception;
  final VoidCallback? onRetry;
  final VoidCallback? onGoBack;
  final VoidCallback? onContactSupport;
  final VoidCallback? onCheckConnection;

  @override
  Widget build(BuildContext context) {
    switch (exception.errorType) {
      // Network errors
      case ApiErrorType.noInternetConnection:
        return NoInternetErrorWidget(
          onRetry: onRetry,
          onCheckConnection: onCheckConnection,
        );

      // Timeout errors
      case ApiErrorType.connectionTimeout:
      case ApiErrorType.receiveTimeout:
      case ApiErrorType.sendTimeout:
      case ApiErrorType.requestTimeout:
        return TimeoutErrorWidget(
          timeoutType: exception.errorType,
          onRetry: onRetry,
        );

      // Server errors
      case ApiErrorType.serverError:
      case ApiErrorType.internalServerError:
      case ApiErrorType.badGateway:
      case ApiErrorType.serviceUnavailable:
      case ApiErrorType.gatewayTimeout:
        return ServerErrorWidget(
          serverErrorType: exception.errorType,
          statusCode: exception.statusCode,
          serverMessage: !exception.isTranslationKey ? exception.message : null,
          onRetry: onRetry,
          onContactSupport: onContactSupport,
        );

      // Client errors
      case ApiErrorType.badRequest:
      case ApiErrorType.unauthorized:
      case ApiErrorType.forbidden:
      case ApiErrorType.notFound:
      case ApiErrorType.methodNotAllowed:
      case ApiErrorType.notAcceptable:
      case ApiErrorType.conflict:
      case ApiErrorType.gone:
      case ApiErrorType.lengthRequired:
      case ApiErrorType.preconditionFailed:
      case ApiErrorType.payloadTooLarge:
      case ApiErrorType.uriTooLong:
      case ApiErrorType.unsupportedMediaType:
      case ApiErrorType.rangeNotSatisfiable:
      case ApiErrorType.expectationFailed:
      case ApiErrorType.tooManyRequests:
        return ClientErrorWidget(
          clientErrorType: exception.errorType,
          statusCode: exception.statusCode,
          serverMessage: !exception.isTranslationKey ? exception.message : null,
          onRetry: onRetry,
          onGoBack: onGoBack,
        );

      // Generic errors
      case ApiErrorType.unknown:
      case ApiErrorType.cancelled:
      case ApiErrorType.other:
      case ApiErrorType.locationServiceDisabled:
      case ApiErrorType.locationPermissionDenied:
      case ApiErrorType.locationPermissionDeniedForever:
        return GenericErrorWidget(
          errorType: exception.errorType,
          serverMessage: !exception.isTranslationKey ? exception.message : null,
          onRetry: onRetry,
          onGoBack: onGoBack,
        );
    }
  }

  /// Factory method to create ApiErrorWidget from any exception
  static Widget fromException(
    Exception exception, {
    VoidCallback? onRetry,
    VoidCallback? onGoBack,
    VoidCallback? onContactSupport,
    VoidCallback? onCheckConnection,
  }) {
    ApiException apiException;

    if (exception is ApiException) {
      apiException = exception;
    } else {
      // Convert any other exception to ApiException
      apiException = ApiException(
        errorType: ApiErrorType.unknown,
        message: exception.toString(),
      );
    }

    return ApiErrorWidget(
      exception: apiException,
      onRetry: onRetry,
      onGoBack: onGoBack,
      onContactSupport: onContactSupport,
      onCheckConnection: onCheckConnection,
    );
  }

  /// Factory method to create ApiErrorWidget from a Failure object
  static Widget fromFailure(
    Failure failure, {
    VoidCallback? onRetry,
    VoidCallback? onGoBack,
    VoidCallback? onContactSupport,
    VoidCallback? onCheckConnection,
  }) {
    ApiErrorType errorType;
    int? statusCode;

    switch (failure.code) {
      case 'error_connection_timeout':
        errorType = ApiErrorType.connectionTimeout;
        break;
      case 'error_send_timeout':
        errorType = ApiErrorType.sendTimeout;
        break;
      case 'error_receive_timeout':
        errorType = ApiErrorType.receiveTimeout;
        break;
      case 'error_request_cancelled':
        errorType = ApiErrorType.cancelled;
        break;
      case 'error_no_internet':
        errorType = ApiErrorType.noInternetConnection;
        break;
      case 'error_bad_request':
        errorType = ApiErrorType.badRequest;
        statusCode = 400;
        break;
      case 'error_unauthorized':
        errorType = ApiErrorType.unauthorized;
        statusCode = 401;
        break;
      case 'error_forbidden':
        errorType = ApiErrorType.forbidden;
        statusCode = 403;
        break;
      case 'error_not_found':
        errorType = ApiErrorType.notFound;
        statusCode = 404;
        break;
      case 'error_conflict':
        errorType = ApiErrorType.conflict;
        statusCode = 409;
        break;
      case 'error_validation':
        errorType = ApiErrorType.badRequest;
        statusCode = 422;
        break;
      case 'error_server':
        errorType = ApiErrorType.internalServerError;
        statusCode = 500;
        break;
      case 'error_no_response':
        errorType = ApiErrorType.serverError;
        break;
      case 'location_service_disabled':
        errorType = ApiErrorType.locationServiceDisabled;
        break;
      case 'location_permission_denied':
        errorType = ApiErrorType.locationPermissionDenied;
        break;
      case 'location_permission_denied_forever':
        errorType = ApiErrorType.locationPermissionDeniedForever;
        break;
      case 'error_bad_certificate':
      case 'error_unknown':
      default:
        errorType = ApiErrorType.unknown;
        break;
    }

    final String errorMsgLower = failure.errorMessage.trim().toLowerCase();

    final bool isDefaultFallback =
        [
          'connection timeout with api server.',
          'send timeout with api server.',
          'receive timeout with api server.',
          'connection failed because of an invalid certificate.',
          'request to api server was cancelled.',
          'no internet connection.',
          'unexpected error occurred. please try again later.',
          'an unexpected error occurred. please try again later.',
          'no response received from server.',
          'bad request.',
          'unauthorized.',
          'forbidden.',
          'resource not found.',
          'conflict occurred.',
          'validation error.',
          'server error. please try again later.',
          'unexpected server error.',
          'internal server error',
          'bad gateway',
          'service unavailable',
        ].contains(errorMsgLower) ||
        errorMsgLower.contains('unexpected error') ||
        errorMsgLower.contains('please try again') ||
        errorMsgLower.contains('server error');

    final apiException = ApiException(
      errorType: errorType,
      message: isDefaultFallback ? failure.code : failure.errorMessage,
      statusCode: statusCode,
      isTranslationKey: isDefaultFallback,
    );

    return ApiErrorWidget(
      exception: apiException,
      onRetry: onRetry,
      onGoBack: onGoBack,
      onContactSupport: onContactSupport,
      onCheckConnection: onCheckConnection,
    );
  }
}
