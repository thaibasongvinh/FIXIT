import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'translation_service.dart';

part 'translation_provider.g.dart';

bool _translationListEquals(List<String> left, List<String> right) {
  if (identical(left, right)) return true;
  if (left.length != right.length) return false;

  for (int i = 0; i < left.length; i++) {
    if (left[i] != right[i]) return false;
  }

  return true;
}

int _translationListHash(List<String> values) => Object.hashAll(values);

@Riverpod(keepAlive: true)
TranslationService translationService(Ref ref) {
  return TranslationService();
}

@Riverpod()
Future<String> translatedText(
  Ref ref,
  String text,
  String targetLang, {
  String sourceLang = 'en',
}) async {
  if (text.trim().isEmpty) return text;
  final service = ref.read(translationServiceProvider);
  return service.translateText(text,
      sourceLang: sourceLang, targetLang: targetLang);
}

@Riverpod()
Future<List<String>> translatedBatch(
  Ref ref,
  List<String> texts,
  String targetLang, {
  String sourceLang = 'en',
}) async {
  if (texts.isEmpty) return [];
  final service = ref.read(translationServiceProvider);
  return service.translateBatch(texts,
      sourceLang: sourceLang, targetLang: targetLang);
}
