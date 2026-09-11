// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$translationServiceHash() =>
    r'65aca261f644d8d980a8bd83d9799aed6b8cebb0';

/// See also [translationService].
@ProviderFor(translationService)
final translationServiceProvider = Provider<TranslationService>.internal(
  translationService,
  name: r'translationServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$translationServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TranslationServiceRef = ProviderRef<TranslationService>;
String _$translatedTextHash() => r'ef429c14269099af2d6fe8a2b5b3938b53a6d6cf';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [translatedText].
@ProviderFor(translatedText)
const translatedTextProvider = TranslatedTextFamily();

/// See also [translatedText].
class TranslatedTextFamily extends Family<AsyncValue<String>> {
  /// See also [translatedText].
  const TranslatedTextFamily();

  /// See also [translatedText].
  TranslatedTextProvider call(
    String text,
    String targetLang, {
    String sourceLang = 'en',
  }) {
    return TranslatedTextProvider(
      text,
      targetLang,
      sourceLang: sourceLang,
    );
  }

  @override
  TranslatedTextProvider getProviderOverride(
    covariant TranslatedTextProvider provider,
  ) {
    return call(
      provider.text,
      provider.targetLang,
      sourceLang: provider.sourceLang,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'translatedTextProvider';
}

/// See also [translatedText].
class TranslatedTextProvider extends AutoDisposeFutureProvider<String> {
  /// See also [translatedText].
  TranslatedTextProvider(
    String text,
    String targetLang, {
    String sourceLang = 'en',
  }) : this._internal(
          (ref) => translatedText(
            ref as TranslatedTextRef,
            text,
            targetLang,
            sourceLang: sourceLang,
          ),
          from: translatedTextProvider,
          name: r'translatedTextProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$translatedTextHash,
          dependencies: TranslatedTextFamily._dependencies,
          allTransitiveDependencies:
              TranslatedTextFamily._allTransitiveDependencies,
          text: text,
          targetLang: targetLang,
          sourceLang: sourceLang,
        );

  TranslatedTextProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.text,
    required this.targetLang,
    required this.sourceLang,
  }) : super.internal();

  final String text;
  final String targetLang;
  final String sourceLang;

  @override
  Override overrideWith(
    FutureOr<String> Function(TranslatedTextRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TranslatedTextProvider._internal(
        (ref) => create(ref as TranslatedTextRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        text: text,
        targetLang: targetLang,
        sourceLang: sourceLang,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _TranslatedTextProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TranslatedTextProvider &&
        other.text == text &&
        other.targetLang == targetLang &&
        other.sourceLang == sourceLang;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, text.hashCode);
    hash = _SystemHash.combine(hash, targetLang.hashCode);
    hash = _SystemHash.combine(hash, sourceLang.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TranslatedTextRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `text` of this provider.
  String get text;

  /// The parameter `targetLang` of this provider.
  String get targetLang;

  /// The parameter `sourceLang` of this provider.
  String get sourceLang;
}

class _TranslatedTextProviderElement
    extends AutoDisposeFutureProviderElement<String> with TranslatedTextRef {
  _TranslatedTextProviderElement(super.provider);

  @override
  String get text => (origin as TranslatedTextProvider).text;
  @override
  String get targetLang => (origin as TranslatedTextProvider).targetLang;
  @override
  String get sourceLang => (origin as TranslatedTextProvider).sourceLang;
}

String _$translatedBatchHash() => r'a44cdee77eaa0ee86c2397ab26d7b595fc6b728f';

/// See also [translatedBatch].
@ProviderFor(translatedBatch)
const translatedBatchProvider = TranslatedBatchFamily();

/// See also [translatedBatch].
class TranslatedBatchFamily extends Family<AsyncValue<List<String>>> {
  /// See also [translatedBatch].
  const TranslatedBatchFamily();

  /// See also [translatedBatch].
  TranslatedBatchProvider call(
    List<String> texts,
    String targetLang, {
    String sourceLang = 'en',
  }) {
    return TranslatedBatchProvider(
      texts,
      targetLang,
      sourceLang: sourceLang,
    );
  }

  @override
  TranslatedBatchProvider getProviderOverride(
    covariant TranslatedBatchProvider provider,
  ) {
    return call(
      provider.texts,
      provider.targetLang,
      sourceLang: provider.sourceLang,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'translatedBatchProvider';
}

/// See also [translatedBatch].
class TranslatedBatchProvider extends AutoDisposeFutureProvider<List<String>> {
  /// See also [translatedBatch].
  TranslatedBatchProvider(
    List<String> texts,
    String targetLang, {
    String sourceLang = 'en',
  }) : this._internal(
          (ref) => translatedBatch(
            ref as TranslatedBatchRef,
            texts,
            targetLang,
            sourceLang: sourceLang,
          ),
          from: translatedBatchProvider,
          name: r'translatedBatchProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$translatedBatchHash,
          dependencies: TranslatedBatchFamily._dependencies,
          allTransitiveDependencies:
              TranslatedBatchFamily._allTransitiveDependencies,
          texts: texts,
          targetLang: targetLang,
          sourceLang: sourceLang,
        );

  TranslatedBatchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.texts,
    required this.targetLang,
    required this.sourceLang,
  }) : super.internal();

  final List<String> texts;
  final String targetLang;
  final String sourceLang;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(TranslatedBatchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TranslatedBatchProvider._internal(
        (ref) => create(ref as TranslatedBatchRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        texts: texts,
        targetLang: targetLang,
        sourceLang: sourceLang,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _TranslatedBatchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TranslatedBatchProvider &&
        _translationListEquals(other.texts, texts) &&
        other.targetLang == targetLang &&
        other.sourceLang == sourceLang;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, _translationListHash(texts));
    hash = _SystemHash.combine(hash, targetLang.hashCode);
    hash = _SystemHash.combine(hash, sourceLang.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TranslatedBatchRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `texts` of this provider.
  List<String> get texts;

  /// The parameter `targetLang` of this provider.
  String get targetLang;

  /// The parameter `sourceLang` of this provider.
  String get sourceLang;
}

class _TranslatedBatchProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with TranslatedBatchRef {
  _TranslatedBatchProviderElement(super.provider);

  @override
  List<String> get texts => (origin as TranslatedBatchProvider).texts;
  @override
  String get targetLang => (origin as TranslatedBatchProvider).targetLang;
  @override
  String get sourceLang => (origin as TranslatedBatchProvider).sourceLang;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
