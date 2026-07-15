// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_flow_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$serviceIssuesHash() => r'd7fbf7ec8eb05e905443a0549ce0bf9b2cf42a3a';

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

/// See also [serviceIssues].
@ProviderFor(serviceIssues)
const serviceIssuesProvider = ServiceIssuesFamily();

/// See also [serviceIssues].
class ServiceIssuesFamily extends Family<AsyncValue<List<ServiceIssueModel>>> {
  /// See also [serviceIssues].
  const ServiceIssuesFamily();

  /// See also [serviceIssues].
  ServiceIssuesProvider call(
    String serviceId,
  ) {
    return ServiceIssuesProvider(
      serviceId,
    );
  }

  @override
  ServiceIssuesProvider getProviderOverride(
    covariant ServiceIssuesProvider provider,
  ) {
    return call(
      provider.serviceId,
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
  String? get name => r'serviceIssuesProvider';
}

/// See also [serviceIssues].
class ServiceIssuesProvider
    extends AutoDisposeFutureProvider<List<ServiceIssueModel>> {
  /// See also [serviceIssues].
  ServiceIssuesProvider(
    String serviceId,
  ) : this._internal(
          (ref) => serviceIssues(
            ref as ServiceIssuesRef,
            serviceId,
          ),
          from: serviceIssuesProvider,
          name: r'serviceIssuesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$serviceIssuesHash,
          dependencies: ServiceIssuesFamily._dependencies,
          allTransitiveDependencies:
              ServiceIssuesFamily._allTransitiveDependencies,
          serviceId: serviceId,
        );

  ServiceIssuesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.serviceId,
  }) : super.internal();

  final String serviceId;

  @override
  Override overrideWith(
    FutureOr<List<ServiceIssueModel>> Function(ServiceIssuesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ServiceIssuesProvider._internal(
        (ref) => create(ref as ServiceIssuesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        serviceId: serviceId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ServiceIssueModel>> createElement() {
    return _ServiceIssuesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceIssuesProvider && other.serviceId == serviceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, serviceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ServiceIssuesRef
    on AutoDisposeFutureProviderRef<List<ServiceIssueModel>> {
  /// The parameter `serviceId` of this provider.
  String get serviceId;
}

class _ServiceIssuesProviderElement
    extends AutoDisposeFutureProviderElement<List<ServiceIssueModel>>
    with ServiceIssuesRef {
  _ServiceIssuesProviderElement(super.provider);

  @override
  String get serviceId => (origin as ServiceIssuesProvider).serviceId;
}

String _$issueProductsHash() => r'268abba11a26e171a06be0d7b4865f4fc7ed470e';

/// See also [issueProducts].
@ProviderFor(issueProducts)
const issueProductsProvider = IssueProductsFamily();

/// See also [issueProducts].
class IssueProductsFamily extends Family<AsyncValue<List<ProductModel>>> {
  /// See also [issueProducts].
  const IssueProductsFamily();

  /// See also [issueProducts].
  IssueProductsProvider call(
    String issueId,
  ) {
    return IssueProductsProvider(
      issueId,
    );
  }

  @override
  IssueProductsProvider getProviderOverride(
    covariant IssueProductsProvider provider,
  ) {
    return call(
      provider.issueId,
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
  String? get name => r'issueProductsProvider';
}

/// See also [issueProducts].
class IssueProductsProvider
    extends AutoDisposeFutureProvider<List<ProductModel>> {
  /// See also [issueProducts].
  IssueProductsProvider(
    String issueId,
  ) : this._internal(
          (ref) => issueProducts(
            ref as IssueProductsRef,
            issueId,
          ),
          from: issueProductsProvider,
          name: r'issueProductsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$issueProductsHash,
          dependencies: IssueProductsFamily._dependencies,
          allTransitiveDependencies:
              IssueProductsFamily._allTransitiveDependencies,
          issueId: issueId,
        );

  IssueProductsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.issueId,
  }) : super.internal();

  final String issueId;

  @override
  Override overrideWith(
    FutureOr<List<ProductModel>> Function(IssueProductsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IssueProductsProvider._internal(
        (ref) => create(ref as IssueProductsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        issueId: issueId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ProductModel>> createElement() {
    return _IssueProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IssueProductsProvider && other.issueId == issueId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, issueId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IssueProductsRef on AutoDisposeFutureProviderRef<List<ProductModel>> {
  /// The parameter `issueId` of this provider.
  String get issueId;
}

class _IssueProductsProviderElement
    extends AutoDisposeFutureProviderElement<List<ProductModel>>
    with IssueProductsRef {
  _IssueProductsProviderElement(super.provider);

  @override
  String get issueId => (origin as IssueProductsProvider).issueId;
}

String _$issueGuideHash() => r'4cc2f8868afe769b96ab70b1a24f9a86951f8f2d';

/// See also [issueGuide].
@ProviderFor(issueGuide)
const issueGuideProvider = IssueGuideFamily();

/// See also [issueGuide].
class IssueGuideFamily extends Family<AsyncValue<GuideModel?>> {
  /// See also [issueGuide].
  const IssueGuideFamily();

  /// See also [issueGuide].
  IssueGuideProvider call(
    String issueId,
  ) {
    return IssueGuideProvider(
      issueId,
    );
  }

  @override
  IssueGuideProvider getProviderOverride(
    covariant IssueGuideProvider provider,
  ) {
    return call(
      provider.issueId,
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
  String? get name => r'issueGuideProvider';
}

/// See also [issueGuide].
class IssueGuideProvider extends AutoDisposeFutureProvider<GuideModel?> {
  /// See also [issueGuide].
  IssueGuideProvider(
    String issueId,
  ) : this._internal(
          (ref) => issueGuide(
            ref as IssueGuideRef,
            issueId,
          ),
          from: issueGuideProvider,
          name: r'issueGuideProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$issueGuideHash,
          dependencies: IssueGuideFamily._dependencies,
          allTransitiveDependencies:
              IssueGuideFamily._allTransitiveDependencies,
          issueId: issueId,
        );

  IssueGuideProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.issueId,
  }) : super.internal();

  final String issueId;

  @override
  Override overrideWith(
    FutureOr<GuideModel?> Function(IssueGuideRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IssueGuideProvider._internal(
        (ref) => create(ref as IssueGuideRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        issueId: issueId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<GuideModel?> createElement() {
    return _IssueGuideProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IssueGuideProvider && other.issueId == issueId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, issueId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IssueGuideRef on AutoDisposeFutureProviderRef<GuideModel?> {
  /// The parameter `issueId` of this provider.
  String get issueId;
}

class _IssueGuideProviderElement
    extends AutoDisposeFutureProviderElement<GuideModel?> with IssueGuideRef {
  _IssueGuideProviderElement(super.provider);

  @override
  String get issueId => (origin as IssueGuideProvider).issueId;
}

String _$issueGuideStepsHash() => r'cdc3db3e144b4645a4225dcb58bdd014133ac3b7';

/// See also [issueGuideSteps].
@ProviderFor(issueGuideSteps)
const issueGuideStepsProvider = IssueGuideStepsFamily();

/// See also [issueGuideSteps].
class IssueGuideStepsFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [issueGuideSteps].
  const IssueGuideStepsFamily();

  /// See also [issueGuideSteps].
  IssueGuideStepsProvider call(
    String guideId,
  ) {
    return IssueGuideStepsProvider(
      guideId,
    );
  }

  @override
  IssueGuideStepsProvider getProviderOverride(
    covariant IssueGuideStepsProvider provider,
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
  String? get name => r'issueGuideStepsProvider';
}

/// See also [issueGuideSteps].
class IssueGuideStepsProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// See also [issueGuideSteps].
  IssueGuideStepsProvider(
    String guideId,
  ) : this._internal(
          (ref) => issueGuideSteps(
            ref as IssueGuideStepsRef,
            guideId,
          ),
          from: issueGuideStepsProvider,
          name: r'issueGuideStepsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$issueGuideStepsHash,
          dependencies: IssueGuideStepsFamily._dependencies,
          allTransitiveDependencies:
              IssueGuideStepsFamily._allTransitiveDependencies,
          guideId: guideId,
        );

  IssueGuideStepsProvider._internal(
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
    FutureOr<List<Map<String, dynamic>>> Function(IssueGuideStepsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IssueGuideStepsProvider._internal(
        (ref) => create(ref as IssueGuideStepsRef),
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
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _IssueGuideStepsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IssueGuideStepsProvider && other.guideId == guideId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, guideId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IssueGuideStepsRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `guideId` of this provider.
  String get guideId;
}

class _IssueGuideStepsProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with IssueGuideStepsRef {
  _IssueGuideStepsProviderElement(super.provider);

  @override
  String get guideId => (origin as IssueGuideStepsProvider).guideId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
