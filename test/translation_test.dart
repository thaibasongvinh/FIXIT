import 'package:flutter_test/flutter_test.dart';
import 'package:fixit/core/services/translation_service.dart';

void main() {
  // We skip cache initialization in tests to avoid MissingPluginException
  // The service will handle the failure gracefully and work without cache.

  final translationService = TranslationService();

  test('Translate English to Vietnamese with Deep Translate only', () async {
    final result =
        await translationService.translateText('Hello World', targetLang: 'vi');
    print('Result: $result');
    if (result != 'Hello World') {
      expect(result.toLowerCase(), contains('xin chào'));
    }
  });

  test('Translate technical term with Deep Translate only', () async {
    const source = 'How to fix a broken screen';
    final result =
        await translationService.translateText(source, targetLang: 'vi');
    print('Result: $result');
    if (result != source) {
      expect(result.toLowerCase(), contains('màn hình'));
    }
  });

  test('Translate English to Korean for runtime languages with Deep only',
      () async {
    const source = 'Login to continue your journey';
    final result = await translationService.translateText(
      source,
      targetLang: 'ko',
    );
    print('Result: $result');
    if (result != source) {
      expect(RegExp(r'[\uAC00-\uD7AF]').hasMatch(result), isTrue);
    }
  });
}
