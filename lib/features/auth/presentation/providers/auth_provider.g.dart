// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authRepositoryHash() => r'adf4f5e44dd9546774f7d20908ba14f307fb839e';

/// See also [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = Provider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthRepositoryRef = ProviderRef<AuthRepository>;
String _$authStateHash() => r'306f295ffccd2c9f2886851f8bebc9fe7a994b03';

/// See also [authState].
@ProviderFor(authState)
final authStateProvider = StreamProvider<models.User?>.internal(
  authState,
  name: r'authStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthStateRef = StreamProviderRef<models.User?>;
String _$currentUserHash() => r'696e111d129b823c1eeacd14c9d45a0c3e702da9';

/// See also [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = StreamProvider<UserModel?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentUserRef = StreamProviderRef<UserModel?>;
String _$currentUserApplicationHash() =>
    r'84d2f65b6a7e5de7800a2f6938516507d2477817';

/// See also [currentUserApplication].
@ProviderFor(currentUserApplication)
final currentUserApplicationProvider =
    FutureProvider<TechApplication?>.internal(
  currentUserApplication,
  name: r'currentUserApplicationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserApplicationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentUserApplicationRef = FutureProviderRef<TechApplication?>;
String _$authNotifierHash() => r'66220ba5c3faf6e1c7922fa572a952135f597865';

/// See also [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    AutoDisposeAsyncNotifierProvider<AuthNotifier, void>.internal(
  AuthNotifier.new,
  name: r'authNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
