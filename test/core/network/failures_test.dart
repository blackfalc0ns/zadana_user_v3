import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zadana_user_v3/core/network/failures.dart';

void main() {
  group('ServerFailure.fromResponse', () {
    test('maps 400 to bad request with defensive message parsing', () {
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 400,
        data: <String, dynamic>{'message': 'Invalid payload'},
      );

      final failure = ServerFailure.fromResponse(response);

      expect(failure.code, 'error_bad_request');
      expect(failure.errorMessage, 'Invalid payload');
    });

    test('maps 404 to not found', () {
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 404,
        data: <String, dynamic>{},
      );

      final failure = ServerFailure.fromResponse(response);

      expect(failure.code, 'error_not_found');
      expect(failure.errorMessage, 'Resource not found.');
    });

    test('falls back safely when response body is plain text', () {
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 503,
        data: 'Service temporarily unavailable',
      );

      final failure = ServerFailure.fromResponse(response);

      expect(failure.code, 'error_unknown');
      expect(failure.errorMessage, 'Service temporarily unavailable');
    });

    test('uses backend code only in unknown status branch when available', () {
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 429,
        data: <String, dynamic>{
          'error': 'Too many requests',
          'code': 'rate_limit',
        },
      );

      final failure = ServerFailure.fromResponse(response);

      expect(failure.code, 'rate_limit');
      expect(failure.errorMessage, 'Too many requests');
    });
  });
}
