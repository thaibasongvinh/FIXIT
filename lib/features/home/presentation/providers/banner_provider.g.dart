// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getBannersUseCaseHash() => r'005097af57843a1d361c8a315d911e77f041bd60';

/// See also [getBannersUseCase].
@ProviderFor(getBannersUseCase)
final getBannersUseCaseProvider =
    AutoDisposeProvider<GetBannersUseCase>.internal(
  getBannersUseCase,
  name: r'getBannersUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getBannersUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetBannersUseCaseRef = AutoDisposeProviderRef<GetBannersUseCase>;
String _$homeBannersHash() => r'844c206db08a098c68b233c7717c6cffe8523fdb';

/// See also [homeBanners].
@ProviderFor(homeBanners)
final homeBannersProvider =
    AutoDisposeStreamProvider<List<BannerModel>>.internal(
  homeBanners,
  name: r'homeBannersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$homeBannersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HomeBannersRef = AutoDisposeStreamProviderRef<List<BannerModel>>;
String _$homeBannerTextHash() => r'db8d34a4773b6507fa83e01f3c44f42675ac73f2';

/// See also [homeBannerText].
@ProviderFor(homeBannerText)
final homeBannerTextProvider = AutoDisposeStreamProvider<String>.internal(
  homeBannerText,
  name: r'homeBannerTextProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeBannerTextHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HomeBannerTextRef = AutoDisposeStreamProviderRef<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
