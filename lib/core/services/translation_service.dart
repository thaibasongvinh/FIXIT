import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'translation_cache_service.dart';

class TranslationService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
  ));

  final TranslationCacheService _cache = TranslationCacheService();
  bool _cacheInitialized = false;

  Future<void> _ensureCache() async {
    if (!_cacheInitialized) {
      await _cache.init();
      _cacheInitialized = true;
    }
  }

  // RapidAPI Configuration - Free Google Translator (by joshimuddin8212)
  static const String _rapidApiKey = '21e3ee3f75msh528b13af08cad2cp1899d3jsn3394e80e2d75';
  static const String _rapidApiHost = 'free-google-translator.p.rapidapi.com';
  static const String _rapidApiUrl = 'https://free-google-translator.p.rapidapi.com/external-api/free-google-translator';
  
  static const String _delimiter = '|';

  Future<String> translateText(
    String text, {
    String? sourceLang,
    required String targetLang,
  }) async {
    final results = await translateBatch([text], sourceLang: sourceLang, targetLang: targetLang);
    return results.isNotEmpty ? results.first : text;
  }

  Future<List<String>> translateBatch(
    List<String> texts, {
    String? sourceLang,
    required String targetLang,
  }) async {
    if (texts.isEmpty) return [];
    await _ensureCache();

    final results = List<String>.filled(texts.length, '');
    final missingTexts = <String>[];
    final missingIndices = <int>[];

    // 1. Check Cache
    for (int i = 0; i < texts.length; i++) {
      if (texts[i].trim().isEmpty) {
        results[i] = texts[i];
      } else {
        final cached = _cache.getTranslation(texts[i], targetLang);
        if (cached != null) {
          results[i] = cached;
        } else {
          missingTexts.add(texts[i]);
          missingIndices.add(i);
        }
      }
    }

    if (missingTexts.isEmpty) return results;

    // 2. Request Free Google Translator API
    try {
      final combinedText = missingTexts.join(' $_delimiter ');
      
      final response = await _dio.post(
        _rapidApiUrl,
        queryParameters: {
          'from': sourceLang ?? 'en',
          'to': targetLang,
          'query': combinedText,
        },
        options: Options(
          headers: {
            'x-rapidapi-key': _rapidApiKey,
            'x-rapidapi-host': _rapidApiHost,
          },
        ),
      );

      if (response.statusCode == 200) {
        String translatedRaw = '';
        if (response.data is Map) {
          translatedRaw = response.data['translation']?.toString() ?? response.data.toString();
        } else {
          translatedRaw = response.data.toString();
        }

        if (translatedRaw.isEmpty) return texts;

        final translatedParts = translatedRaw.split(_delimiter).map((s) => s.trim()).toList();
        final cacheBatch = <String, String>{};
        
        for (int i = 0; i < missingTexts.length; i++) {
          if (i < translatedParts.length) {
            final val = translatedParts[i];
            if (val.toLowerCase() != missingTexts[i].toLowerCase()) {
              results[missingIndices[i]] = val;
              cacheBatch[missingTexts[i]] = val;
            } else {
              results[missingIndices[i]] = missingTexts[i];
            }
          } else {
            results[missingIndices[i]] = missingTexts[i];
          }
        }
        
        if (cacheBatch.isNotEmpty) {
          await _cache.saveBatch(cacheBatch, targetLang);
        }
        
        return results;
      }
    } catch (e) {
      debugPrint('TranslationService Error: $e');
    }

    for (int i = 0; i < missingIndices.length; i++) {
      results[missingIndices[i]] = missingTexts[i];
    }
    return results;
  }
}
