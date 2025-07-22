import 'package:chat_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('isDarkMode toggles value', () {
    expect(isDarkMode.value, false);

    isDarkMode.value = true;
    expect(isDarkMode.value, true);

    isDarkMode.value = false;
    expect(isDarkMode.value, false);
  });
}
