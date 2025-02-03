import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_chat/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('MessageCardModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
