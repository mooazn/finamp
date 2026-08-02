import 'dart:async';
import 'dart:collection';

import 'package:chopper/chopper.dart' as chopper;
import 'package:logging/logging.dart';

String redactSensitiveLogText(String input) {
  var output = input.replaceAllMapped(
    RegExp(r'(^|\n)(authorization:\s*)[^\r\n]*', caseSensitive: false),
    (match) => '${match.group(1)}${match.group(2)}[REDACTED]',
  );
  output = output.replaceAllMapped(
    RegExp(r'("(?:AccessToken|Token)"\s*:\s*")[^"]*(")', caseSensitive: false),
    (match) => '${match.group(1)}[REDACTED]${match.group(2)}',
  );
  output = output.replaceAllMapped(
    RegExp(r'([?&](?:api_key|access_token|token)=)[^&\s]+', caseSensitive: false),
    (match) => '${match.group(1)}[REDACTED]',
  );
  return output;
}

/// A logger that aggregates the request and response logs from Chopper.
/// Once a request (or response) is completed,
/// the whole request log is flushed to the delegated chopperLogger.
///
/// All other operations are delegated by default.
class ChopperAggregateLogger implements Logger {
  final Logger _delegate = chopper.chopperLogger;

  final Map<chopper.Request, StringBuffer> _requests = HashMap();

  final Map<chopper.Response<dynamic>, StringBuffer> _responses = HashMap();

  @override
  String get name => _delegate.name;

  @override
  String get fullName => _delegate.fullName;

  @override
  Logger? get parent => _delegate.parent;

  @override
  Level get level => _delegate.level;

  @override
  set level(Level? value) {
    _delegate.level = value;
  }

  @override
  Map<String, Logger> get children => _delegate.children;

  @override
  void log(Level logLevel, Object? message, [Object? error, StackTrace? stackTrace, Zone? zone]) {
    if (message is chopper.ChopperLogRecord) {
      final sanitizedMessage = redactSensitiveLogText(message.message);
      if (message.request != null) {
        _requests[message.request]?.writeln(sanitizedMessage);
        return;
      } else if (message.response != null) {
        _responses[message.response]?.writeln(sanitizedMessage);
        return;
      }
    }
    _delegate.log(logLevel, message, error, stackTrace, zone);
  }

  void onStartRequest(chopper.Request request) {
    _requests[request] = StringBuffer();
  }

  void onEndRequest(chopper.Request request) {
    info(_requests.remove(request)?.toString().trim());
  }

  void onStartResponse(chopper.Response<dynamic> response) {
    _responses[response] = StringBuffer();
  }

  void onEndResponse(chopper.Response<dynamic> response) {
    info(_responses.remove(response)?.toString().trim());
  }

  @override
  Stream<Level?> get onLevelChanged => _delegate.onLevelChanged;

  @override
  Stream<LogRecord> get onRecord => _delegate.onRecord;

  @override
  void clearListeners() {
    _delegate.clearListeners();
  }

  @override
  bool isLoggable(Level value) {
    return _delegate.isLoggable(value);
  }

  @override
  void finest(Object? message, [Object? error, StackTrace? stackTrace]) =>
      log(Level.FINEST, message, error, stackTrace);

  @override
  void finer(Object? message, [Object? error, StackTrace? stackTrace]) => log(Level.FINER, message, error, stackTrace);

  @override
  void fine(Object? message, [Object? error, StackTrace? stackTrace]) => log(Level.FINE, message, error, stackTrace);

  @override
  void config(Object? message, [Object? error, StackTrace? stackTrace]) =>
      log(Level.CONFIG, message, error, stackTrace);

  @override
  void info(Object? message, [Object? error, StackTrace? stackTrace]) => log(Level.INFO, message, error, stackTrace);

  @override
  void warning(Object? message, [Object? error, StackTrace? stackTrace]) =>
      log(Level.WARNING, message, error, stackTrace);

  @override
  void severe(Object? message, [Object? error, StackTrace? stackTrace]) =>
      log(Level.SEVERE, message, error, stackTrace);

  @override
  void shout(Object? message, [Object? error, StackTrace? stackTrace]) => log(Level.SHOUT, message, error, stackTrace);
}
