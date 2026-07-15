// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$walletRepositoryHash() => r'e04a5d186bb179fc4546711a1d62272c52cd6822';

/// See also [walletRepository].
@ProviderFor(walletRepository)
final walletRepositoryProvider = AutoDisposeProvider<WalletRepository>.internal(
  walletRepository,
  name: r'walletRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$walletRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WalletRepositoryRef = AutoDisposeProviderRef<WalletRepository>;
String _$userWalletHash() => r'c996ab71de93df73b60e5242409804648506a825';

/// See also [userWallet].
@ProviderFor(userWallet)
final userWalletProvider = AutoDisposeStreamProvider<WalletModel?>.internal(
  userWallet,
  name: r'userWalletProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userWalletHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserWalletRef = AutoDisposeStreamProviderRef<WalletModel?>;
String _$walletTransactionsHash() =>
    r'36a61571fb4d57ff29db78e97cf405a5d7dc5498';

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

/// See also [walletTransactions].
@ProviderFor(walletTransactions)
const walletTransactionsProvider = WalletTransactionsFamily();

/// See also [walletTransactions].
class WalletTransactionsFamily
    extends Family<AsyncValue<List<TransactionModel>>> {
  /// See also [walletTransactions].
  const WalletTransactionsFamily();

  /// See also [walletTransactions].
  WalletTransactionsProvider call(
    String walletId,
  ) {
    return WalletTransactionsProvider(
      walletId,
    );
  }

  @override
  WalletTransactionsProvider getProviderOverride(
    covariant WalletTransactionsProvider provider,
  ) {
    return call(
      provider.walletId,
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
  String? get name => r'walletTransactionsProvider';
}

/// See also [walletTransactions].
class WalletTransactionsProvider
    extends AutoDisposeStreamProvider<List<TransactionModel>> {
  /// See also [walletTransactions].
  WalletTransactionsProvider(
    String walletId,
  ) : this._internal(
          (ref) => walletTransactions(
            ref as WalletTransactionsRef,
            walletId,
          ),
          from: walletTransactionsProvider,
          name: r'walletTransactionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$walletTransactionsHash,
          dependencies: WalletTransactionsFamily._dependencies,
          allTransitiveDependencies:
              WalletTransactionsFamily._allTransitiveDependencies,
          walletId: walletId,
        );

  WalletTransactionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.walletId,
  }) : super.internal();

  final String walletId;

  @override
  Override overrideWith(
    Stream<List<TransactionModel>> Function(WalletTransactionsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WalletTransactionsProvider._internal(
        (ref) => create(ref as WalletTransactionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        walletId: walletId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<TransactionModel>> createElement() {
    return _WalletTransactionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WalletTransactionsProvider && other.walletId == walletId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, walletId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WalletTransactionsRef
    on AutoDisposeStreamProviderRef<List<TransactionModel>> {
  /// The parameter `walletId` of this provider.
  String get walletId;
}

class _WalletTransactionsProviderElement
    extends AutoDisposeStreamProviderElement<List<TransactionModel>>
    with WalletTransactionsRef {
  _WalletTransactionsProviderElement(super.provider);

  @override
  String get walletId => (origin as WalletTransactionsProvider).walletId;
}

String _$walletNotifierHash() => r'0636cb530d0eb30d99ee1ce8d2ff1bc88093d563';

/// See also [WalletNotifier].
@ProviderFor(WalletNotifier)
final walletNotifierProvider =
    AutoDisposeAsyncNotifierProvider<WalletNotifier, void>.internal(
  WalletNotifier.new,
  name: r'walletNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$walletNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WalletNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
