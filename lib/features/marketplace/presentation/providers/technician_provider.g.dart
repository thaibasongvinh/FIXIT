// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technician_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$technicianRepositoryHash() =>
    r'e41b27286bad5ddc91c1537b4b1fe013c4778e77';

/// See also [technicianRepository].
@ProviderFor(technicianRepository)
final technicianRepositoryProvider =
    AutoDisposeProvider<TechnicianRepository>.internal(
  technicianRepository,
  name: r'technicianRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$technicianRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TechnicianRepositoryRef = AutoDisposeProviderRef<TechnicianRepository>;
String _$technicianDetailHash() => r'8bc4fffb42da3d72c139fb7f7f74cbae893840d7';

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

/// See also [technicianDetail].
@ProviderFor(technicianDetail)
const technicianDetailProvider = TechnicianDetailFamily();

/// See also [technicianDetail].
class TechnicianDetailFamily extends Family<AsyncValue<TechnicianModel?>> {
  /// See also [technicianDetail].
  const TechnicianDetailFamily();

  /// See also [technicianDetail].
  TechnicianDetailProvider call(
    String techId,
  ) {
    return TechnicianDetailProvider(
      techId,
    );
  }

  @override
  TechnicianDetailProvider getProviderOverride(
    covariant TechnicianDetailProvider provider,
  ) {
    return call(
      provider.techId,
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
  String? get name => r'technicianDetailProvider';
}

/// See also [technicianDetail].
class TechnicianDetailProvider
    extends AutoDisposeFutureProvider<TechnicianModel?> {
  /// See also [technicianDetail].
  TechnicianDetailProvider(
    String techId,
  ) : this._internal(
          (ref) => technicianDetail(
            ref as TechnicianDetailRef,
            techId,
          ),
          from: technicianDetailProvider,
          name: r'technicianDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$technicianDetailHash,
          dependencies: TechnicianDetailFamily._dependencies,
          allTransitiveDependencies:
              TechnicianDetailFamily._allTransitiveDependencies,
          techId: techId,
        );

  TechnicianDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.techId,
  }) : super.internal();

  final String techId;

  @override
  Override overrideWith(
    FutureOr<TechnicianModel?> Function(TechnicianDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TechnicianDetailProvider._internal(
        (ref) => create(ref as TechnicianDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        techId: techId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TechnicianModel?> createElement() {
    return _TechnicianDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TechnicianDetailProvider && other.techId == techId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, techId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TechnicianDetailRef on AutoDisposeFutureProviderRef<TechnicianModel?> {
  /// The parameter `techId` of this provider.
  String get techId;
}

class _TechnicianDetailProviderElement
    extends AutoDisposeFutureProviderElement<TechnicianModel?>
    with TechnicianDetailRef {
  _TechnicianDetailProviderElement(super.provider);

  @override
  String get techId => (origin as TechnicianDetailProvider).techId;
}

String _$techniciansNotifierHash() =>
    r'384e874bcc85bc295e703b9233cba7a07e0156ba';

/// See also [TechniciansNotifier].
@ProviderFor(TechniciansNotifier)
final techniciansNotifierProvider = AutoDisposeAsyncNotifierProvider<
    TechniciansNotifier, List<TechnicianModel>>.internal(
  TechniciansNotifier.new,
  name: r'techniciansNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$techniciansNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TechniciansNotifier = AutoDisposeAsyncNotifier<List<TechnicianModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
