// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isarDatabaseHash() => r'f65ecda25d68561c852436b40d721be8b1986d17';

/// See also [isarDatabase].
@ProviderFor(isarDatabase)
final isarDatabaseProvider = FutureProvider<Isar>.internal(
  isarDatabase,
  name: r'isarDatabaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isarDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsarDatabaseRef = FutureProviderRef<Isar>;
String _$localGuideRepositoryHash() =>
    r'a947b76a3afd3239c4f1b9b78222815b90ba2e53';

/// See also [LocalGuideRepository].
@ProviderFor(LocalGuideRepository)
final localGuideRepositoryProvider = AutoDisposeAsyncNotifierProvider<
    LocalGuideRepository, List<LocalGuide>>.internal(
  LocalGuideRepository.new,
  name: r'localGuideRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localGuideRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LocalGuideRepository = AutoDisposeAsyncNotifier<List<LocalGuide>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
