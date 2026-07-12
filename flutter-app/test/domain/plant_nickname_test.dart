import 'package:flutter_test/flutter_test.dart';
import 'package:zeimoto/domain/plants.dart';

void main() {
  group('defaultNickname', () {
    test('uses the last species token and a two-digit progressive suffix', () {
      expect(defaultNickname('Acer palmatum', 2), 'palmatum_03');
    });

    test('uses the only token when the species has a single word', () {
      expect(defaultNickname('Ginkgo', 0), 'ginkgo_01');
    });

    test('returns the provided nickname when it is not blank', () {
      expect(defaultNickname('Acer palmatum', 2, nickname: 'Momiji'), 'Momiji');
    });

    test(
      'falls back to the generated nickname when the nickname is whitespace',
      () {
        expect(
          defaultNickname('Acer palmatum', 2, nickname: '   '),
          'palmatum_03',
        );
      },
    );
  });
}
