// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guide_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$guideRepositoryHash() => r'5f5d79dfb00fea83e2e78a454cf3716a1e95706e';

/// See also [guideRepository].
@ProviderFor(guideRepository)
final guideRepositoryProvider = AutoDisposeProvider<GuideRepository>.internal(
  guideRepository,
  name: r'guideRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$guideRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GuideRepositoryRef = AutoDisposeProviderRef<GuideRepository>;
String _$guideDetailHash() => r'f172c057cd54369c3927f04bf8a74d9cf1b26e95';

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

/// See also [guideDetail].
@ProviderFor(guideDetail)
const guideDetailProvider = GuideDetailFamily();

/// See also [guideDetail].
class GuideDetailFamily extends Family<AsyncValue<GuideModel?>> {
  /// See also [guideDetail].
  const GuideDetailFamily();

  /// See also [guideDetail].
  GuideDetailProvider call(
    String guideId,
  ) {
    return GuideDetailProvider(
      guideId,
    );
  }

  @override
  GuideDetailProvider getProviderOverride(
    covariant GuideDetailProvider provider,
  ) {
    return call(
      provider.guideId,
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
  String? get name => r'guideDetailProvider';
}

/// See also [guideDetail].
class GuideDetailProvider extends AutoDisposeFutureProvider<GuideModel?> {
  /// See also [guideDetail].
  GuideDetailProvider(
    String guideId,
  ) : this._internal(
          (ref) => guideDetail(
            ref as GuideDetailRef,
            guideId,
          ),
          from: guideDetailProvider,
          name: r'guideDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$guideDetailHash,
          dependencies: GuideDetailFamily._dependencies,
          allTransitiveDependencies:
              GuideDetailFamily._allTransitiveDependencies,
          guideId: guideId,
        );

  GuideDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.guideId,
  }) : super.internal();

  final String guideId;

  @override
  Override overrideWith(
    FutureOr<GuideModel?> Function(GuideDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GuideDetailProvider._internal(
        (ref) => create(ref as GuideDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        guideId: guideId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<GuideModel?> createElement() {
    return _GuideDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GuideDetailProvider && other.guideId == guideId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, guideId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GuideDetailRef on AutoDisposeFutureProviderRef<GuideModel?> {
  /// The parameter `guideId` of this provider.
  String get guideId;
}

class _GuideDetailProviderElement
    extends AutoDisposeFutureProviderElement<GuideModel?> with GuideDetailRef {
  _GuideDetailProviderElement(super.provider);

  @override
  String get guideId => (origin as GuideDetailProvider).guideId;
}

String _$guideStepsHash() => r'f052354ded55498d442efef0f968383123cdfe87';

/// See also [guideSteps].
@ProviderFor(guideSteps)
const guideStepsProvider = GuideStepsFamily();

/// See also [guideSteps].
class GuideStepsFamily extends Family<AsyncValue<List<StepModel>>> {
  /// See also [guideSteps].
  const GuideStepsFamily();

  /// See also [guideSteps].
  GuideStepsProvider call(
    String guideId,
  ) {
    return GuideStepsProvider(
      guideId,
    );
  }

  @override
  GuideStepsProvider getProviderOverride(
    covariant GuideStepsProvider provider,
  ) {
    return call(
      provider.guideId,
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
  String? get name => r'guideStepsProvider';
}

/// See also [guideSteps].
class GuideStepsProvider extends AutoDisposeStreamProvider<List<StepModel>> {
  /// See also [guideSteps].
  GuideStepsProvider(
    String guideId,
  ) : this._internal(
          (ref) => guideSteps(
            ref as GuideStepsRef,
            guideId,
          ),
          from: guideStepsProvider,
          name: r'guideStepsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$guideStepsHash,
          dependencies: GuideStepsFamily._dependencies,
          allTransitiveDependencies:
              GuideStepsFamily._allTransitiveDependencies,
          guideId: guideId,
        );

  GuideStepsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.guideId,
  }) : super.internal();

  final String guideId;

  @override
  Override overrideWith(
    Stream<List<StepModel>> Function(GuideStepsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GuideStepsProvider._internal(
        (ref) => create(ref as GuideStepsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        guideId: guideId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<StepModel>> createElement() {
    return _GuideStepsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GuideStepsProvider && other.guideId == guideId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, guideId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GuideStepsRef on AutoDisposeStreamProviderRef<List<StepModel>> {
  /// The parameter `guideId` of this provider.
  String get guideId;
}

class _GuideStepsProviderElement
    extends AutoDisposeStreamProviderElement<List<StepModel>>
    with GuideStepsRef {
  _GuideStepsProviderElement(super.provider);

  @override
  String get guideId => (origin as GuideStepsProvider).guideId;
}

String _$guideBookmarkStatusHash() =>
    r'2ecb9dd2264412ddf3bb0ec18425257d96b2a33c';

/// See also [guideBookmarkStatus].
@ProviderFor(guideBookmarkStatus)
const guideBookmarkStatusProvider = GuideBookmarkStatusFamily();

/// See also [guideBookmarkStatus].
class GuideBookmarkStatusFamily extends Family<AsyncValue<bool>> {
  /// See also [guideBookmarkStatus].
  const GuideBookmarkStatusFamily();

  /// See also [guideBookmarkStatus].
  GuideBookmarkStatusProvider call(
    String guideId,
  ) {
    return GuideBookmarkStatusProvider(
      guideId,
    );
  }

  @override
  GuideBookmarkStatusProvider getProviderOverride(
    covariant GuideBookmarkStatusProvider provider,
  ) {
    return call(
      provider.guideId,
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
  String? get name => r'guideBookmarkStatusProvider';
}

/// See also [guideBookmarkStatus].
class GuideBookmarkStatusProvider extends AutoDisposeStreamProvider<bool> {
  /// See also [guideBookmarkStatus].
  GuideBookmarkStatusProvider(
    String guideId,
  ) : this._internal(
          (ref) => guideBookmarkStatus(
            ref as GuideBookmarkStatusRef,
            guideId,
          ),
          from: guideBookmarkStatusProvider,
          name: r'guideBookmarkStatusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$guideBookmarkStatusHash,
          dependencies: GuideBookmarkStatusFamily._dependencies,
          allTransitiveDependencies:
              GuideBookmarkStatusFamily._allTransitiveDependencies,
          guideId: guideId,
        );

  GuideBookmarkStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.guideId,
  }) : super.internal();

  final String guideId;

  @override
  Override overrideWith(
    Stream<bool> Function(GuideBookmarkStatusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GuideBookmarkStatusProvider._internal(
        (ref) => create(ref as GuideBookmarkStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        guideId: guideId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<bool> createElement() {
    return _GuideBookmarkStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GuideBookmarkStatusProvider && other.guideId == guideId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, guideId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GuideBookmarkStatusRef on AutoDisposeStreamProviderRef<bool> {
  /// The parameter `guideId` of this provider.
  String get guideId;
}

class _GuideBookmarkStatusProviderElement
    extends AutoDisposeStreamProviderElement<bool> with GuideBookmarkStatusRef {
  _GuideBookmarkStatusProviderElement(super.provider);

  @override
  String get guideId => (origin as GuideBookmarkStatusProvider).guideId;
}

String _$guidesFeedNotifierHash() =>
    r'60073fa6d42e5848e5ba7c59ff8ef5d3d3e81c76';

/// See also [GuidesFeedNotifier].
@ProviderFor(GuidesFeedNotifier)
final guidesFeedNotifierProvider = AutoDisposeAsyncNotifierProvider<
    GuidesFeedNotifier, GuidesFeedState>.internal(
  GuidesFeedNotifier.new,
  name: r'guidesFeedNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$guidesFeedNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GuidesFeedNotifier = AutoDisposeAsyncNotifier<GuidesFeedState>;
String _$guideReaderNotifierHash() =>
    r'240c01dab12dd1caca28108611787456ca2d7e58';

/// See also [GuideReaderNotifier].
@ProviderFor(GuideReaderNotifier)
final guideReaderNotifierProvider =
    AutoDisposeNotifierProvider<GuideReaderNotifier, int>.internal(
  GuideReaderNotifier.new,
  name: r'guideReaderNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$guideReaderNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GuideReaderNotifier = AutoDisposeNotifier<int>;
String _$sessionViewedGuidesHash() =>
    r'602c6393159ff18618e9cfd513a30bb61cc1059d';

/// See also [SessionViewedGuides].
@ProviderFor(SessionViewedGuides)
final sessionViewedGuidesProvider =
    AutoDisposeNotifierProvider<SessionViewedGuides, Set<String>>.internal(
  SessionViewedGuides.new,
  name: r'sessionViewedGuidesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sessionViewedGuidesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SessionViewedGuides = AutoDisposeNotifier<Set<String>>;
String _$createGuideNotifierHash() =>
    r'8d395c05e9e1fc244c07adae6c16242e61808768';

/// See also [CreateGuideNotifier].
@ProviderFor(CreateGuideNotifier)
final createGuideNotifierProvider = AutoDisposeNotifierProvider<
    CreateGuideNotifier, AsyncValue<String?>>.internal(
  CreateGuideNotifier.new,
  name: r'createGuideNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createGuideNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreateGuideNotifier = AutoDisposeNotifier<AsyncValue<String?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
