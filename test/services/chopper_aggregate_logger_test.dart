import 'package:finamp/services/chopper_aggregate_logger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('redactSensitiveLogText', () {
    test('redacts authorization headers', () {
      const secret = 'private-auth-token';
      final result = redactSensitiveLogText('Authorization: MediaBrowser Token="$secret"');

      expect(result, contains('[REDACTED]'));
      expect(result, isNot(contains(secret)));
    });

    test('redacts token response fields and query parameters', () {
      const secret = 'private-access-token';
      final result = redactSensitiveLogText('{"AccessToken":"$secret"}\nGET /path?api_key=$secret&limit=1');

      expect(result, isNot(contains(secret)));
      expect('[REDACTED]'.allMatches(result), hasLength(2));
    });
  });
}
