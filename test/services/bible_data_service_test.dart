import 'package:flutter_test/flutter_test.dart';
import 'package:companion/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('BibleDataServiceTest -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
