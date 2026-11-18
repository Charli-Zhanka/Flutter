import '../../core/api/api_exception.dart';

String errorText(ApiException e) => switch (e) {
      NoConnectionException() => 'No connection. Check your network.',
      ServerException(:final status) => 'Server error ($status). Try later.',
      NotFoundException() => 'Not found.',
      UnauthorizedException() => 'You are not authorized.',
      BadResponseException() => 'The server sent something unreadable.',
    };
