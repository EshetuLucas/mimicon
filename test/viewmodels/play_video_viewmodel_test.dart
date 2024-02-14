import 'package:flutter_test/flutter_test.dart';
import 'package:mimicon/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('PlayVideoViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}

