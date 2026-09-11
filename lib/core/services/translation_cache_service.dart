import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class TranslationCacheService {
  static const String _boxName = 'translations_cache';
  Box? _box;

  Future<void> init() async {
    if (_box != null) return;
    try {
      if (!kIsWeb) {
        final directory = await getApplicationDocumentsDirectory();
        Hive.init(directory.path);
      }
      _box = await Hive.openBox(_boxName);
      debugPrint('TranslationCacheService: Initialized with ${_box?.length ?? 0} entries');
    } catch (e) {
      debugPrint('TranslationCacheService: Failed to initialize Hive: $e');
    }
  }

  /// Generates a compatible Hive key (max 255 chars) using MD5 hash.
  /// Format: targetLang_md5(sourceText)
  String _generateKey(String text, String targetLang) {
    final cleanText = text.trim().toLowerCase();
    final hash = md5.convert(utf8.encode(cleanText)).toString();
    return '${targetLang}_$hash';
  }

  String? getTranslation(String text, String targetLang) {
    if (_box == null) return null;
    final key = _generateKey(text, targetLang);
    return _box!.get(key);
  }

  Future<void> saveTranslation(String sourceText, String translatedText, String targetLang) async {
    if (_box == null) return;
    final key = _generateKey(sourceText, targetLang);
    await _box!.put(key, translatedText);
  }

  Future<void> saveBatch(Map<String, String> translations, String targetLang) async {
    if (_box == null) return;
    final Map<String, String> keyedTranslations = {};
    translations.forEach((source, translated) {
      keyedTranslations[_generateKey(source, targetLang)] = translated;
    });
    await _box!.putAll(keyedTranslations);
  }

  Future<void> clear() async {
    await _box?.clear();
  }
}
