// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookingRepositoryHash() => r'e8fb93b70946abeac054f405137bdb44bc38c844';

/// See also [bookingRepository].
@ProviderFor(bookingRepository)
final bookingRepositoryProvider =
    AutoDisposeProvider<BookingRepository>.internal(
  bookingRepository,
  name: r'bookingRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bookingRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BookingRepositoryRef = AutoDisposeProviderRef<BookingRepository>;
String _$customerBookingsHash() => r'9186220387b59ffdf87dacf800d79d116077bfc8';

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

/// See also [customerBookings].
@ProviderFor(customerBookings)
const customerBookingsProvider = CustomerBookingsFamily();

/// See also [customerBookings].
class CustomerBookingsFamily extends Family<AsyncValue<List<BookingModel>>> {
  /// See also [customerBookings].
  const CustomerBookingsFamily();

  /// See also [customerBookings].
  CustomerBookingsProvider call(
    String customerId,
  ) {
    return CustomerBookingsProvider(
      customerId,
    );
  }

  @override
  CustomerBookingsProvider getProviderOverride(
    covariant CustomerBookingsProvider provider,
  ) {
    return call(
      provider.customerId,
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
  String? get name => r'customerBookingsProvider';
}

/// See also [customerBookings].
class CustomerBookingsProvider
    extends AutoDisposeStreamProvider<List<BookingModel>> {
  /// See also [customerBookings].
  CustomerBookingsProvider(
    String customerId,
  ) : this._internal(
          (ref) => customerBookings(
            ref as CustomerBookingsRef,
            customerId,
          ),
          from: customerBookingsProvider,
          name: r'customerBookingsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$customerBookingsHash,
          dependencies: CustomerBookingsFamily._dependencies,
          allTransitiveDependencies:
              CustomerBookingsFamily._allTransitiveDependencies,
          customerId: customerId,
        );

  CustomerBookingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.customerId,
  }) : super.internal();

  final String customerId;

  @override
  Override overrideWith(
    Stream<List<BookingModel>> Function(CustomerBookingsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomerBookingsProvider._internal(
        (ref) => create(ref as CustomerBookingsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        customerId: customerId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<BookingModel>> createElement() {
    return _CustomerBookingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerBookingsProvider && other.customerId == customerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, customerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CustomerBookingsRef on AutoDisposeStreamProviderRef<List<BookingModel>> {
  /// The parameter `customerId` of this provider.
  String get customerId;
}

class _CustomerBookingsProviderElement
    extends AutoDisposeStreamProviderElement<List<BookingModel>>
    with CustomerBookingsRef {
  _CustomerBookingsProviderElement(super.provider);

  @override
  String get customerId => (origin as CustomerBookingsProvider).customerId;
}

String _$technicianBookingsHash() =>
    r'b9e4028921ac109cb60ca37e5f9ec2252ba9232e';

/// See also [technicianBookings].
@ProviderFor(technicianBookings)
const technicianBookingsProvider = TechnicianBookingsFamily();

/// See also [technicianBookings].
class TechnicianBookingsFamily extends Family<AsyncValue<List<BookingModel>>> {
  /// See also [technicianBookings].
  const TechnicianBookingsFamily();

  /// See also [technicianBookings].
  TechnicianBookingsProvider call(
    String technicianId,
  ) {
    return TechnicianBookingsProvider(
      technicianId,
    );
  }

  @override
  TechnicianBookingsProvider getProviderOverride(
    covariant TechnicianBookingsProvider provider,
  ) {
    return call(
      provider.technicianId,
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
  String? get name => r'technicianBookingsProvider';
}

/// See also [technicianBookings].
class TechnicianBookingsProvider
    extends AutoDisposeStreamProvider<List<BookingModel>> {
  /// See also [technicianBookings].
  TechnicianBookingsProvider(
    String technicianId,
  ) : this._internal(
          (ref) => technicianBookings(
            ref as TechnicianBookingsRef,
            technicianId,
          ),
          from: technicianBookingsProvider,
          name: r'technicianBookingsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$technicianBookingsHash,
          dependencies: TechnicianBookingsFamily._dependencies,
          allTransitiveDependencies:
              TechnicianBookingsFamily._allTransitiveDependencies,
          technicianId: technicianId,
        );

  TechnicianBookingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.technicianId,
  }) : super.internal();

  final String technicianId;

  @override
  Override overrideWith(
    Stream<List<BookingModel>> Function(TechnicianBookingsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TechnicianBookingsProvider._internal(
        (ref) => create(ref as TechnicianBookingsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        technicianId: technicianId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<BookingModel>> createElement() {
    return _TechnicianBookingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TechnicianBookingsProvider &&
        other.technicianId == technicianId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, technicianId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TechnicianBookingsRef
    on AutoDisposeStreamProviderRef<List<BookingModel>> {
  /// The parameter `technicianId` of this provider.
  String get technicianId;
}

class _TechnicianBookingsProviderElement
    extends AutoDisposeStreamProviderElement<List<BookingModel>>
    with TechnicianBookingsRef {
  _TechnicianBookingsProviderElement(super.provider);

  @override
  String get technicianId =>
      (origin as TechnicianBookingsProvider).technicianId;
}

String _$bookingDetailHash() => r'57c7262a13697392211bae6edde5cc8f45077b33';

/// See also [bookingDetail].
@ProviderFor(bookingDetail)
const bookingDetailProvider = BookingDetailFamily();

/// See also [bookingDetail].
class BookingDetailFamily extends Family<AsyncValue<BookingModel?>> {
  /// See also [bookingDetail].
  const BookingDetailFamily();

  /// See also [bookingDetail].
  BookingDetailProvider call(
    String bookingId,
  ) {
    return BookingDetailProvider(
      bookingId,
    );
  }

  @override
  BookingDetailProvider getProviderOverride(
    covariant BookingDetailProvider provider,
  ) {
    return call(
      provider.bookingId,
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
  String? get name => r'bookingDetailProvider';
}

/// See also [bookingDetail].
class BookingDetailProvider extends AutoDisposeStreamProvider<BookingModel?> {
  /// See also [bookingDetail].
  BookingDetailProvider(
    String bookingId,
  ) : this._internal(
          (ref) => bookingDetail(
            ref as BookingDetailRef,
            bookingId,
          ),
          from: bookingDetailProvider,
          name: r'bookingDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookingDetailHash,
          dependencies: BookingDetailFamily._dependencies,
          allTransitiveDependencies:
              BookingDetailFamily._allTransitiveDependencies,
          bookingId: bookingId,
        );

  BookingDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookingId,
  }) : super.internal();

  final String bookingId;

  @override
  Override overrideWith(
    Stream<BookingModel?> Function(BookingDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookingDetailProvider._internal(
        (ref) => create(ref as BookingDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookingId: bookingId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<BookingModel?> createElement() {
    return _BookingDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookingDetailProvider && other.bookingId == bookingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BookingDetailRef on AutoDisposeStreamProviderRef<BookingModel?> {
  /// The parameter `bookingId` of this provider.
  String get bookingId;
}

class _BookingDetailProviderElement
    extends AutoDisposeStreamProviderElement<BookingModel?>
    with BookingDetailRef {
  _BookingDetailProviderElement(super.provider);

  @override
  String get bookingId => (origin as BookingDetailProvider).bookingId;
}

String _$technicianReviewsHash() => r'97b1b0360f7bab51bf8027e63bce805739cc4dbb';

/// See also [technicianReviews].
@ProviderFor(technicianReviews)
const technicianReviewsProvider = TechnicianReviewsFamily();

/// See also [technicianReviews].
class TechnicianReviewsFamily extends Family<AsyncValue<List<ReviewModel>>> {
  /// See also [technicianReviews].
  const TechnicianReviewsFamily();

  /// See also [technicianReviews].
  TechnicianReviewsProvider call(
    String technicianId,
  ) {
    return TechnicianReviewsProvider(
      technicianId,
    );
  }

  @override
  TechnicianReviewsProvider getProviderOverride(
    covariant TechnicianReviewsProvider provider,
  ) {
    return call(
      provider.technicianId,
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
  String? get name => r'technicianReviewsProvider';
}

/// See also [technicianReviews].
class TechnicianReviewsProvider
    extends AutoDisposeFutureProvider<List<ReviewModel>> {
  /// See also [technicianReviews].
  TechnicianReviewsProvider(
    String technicianId,
  ) : this._internal(
          (ref) => technicianReviews(
            ref as TechnicianReviewsRef,
            technicianId,
          ),
          from: technicianReviewsProvider,
          name: r'technicianReviewsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$technicianReviewsHash,
          dependencies: TechnicianReviewsFamily._dependencies,
          allTransitiveDependencies:
              TechnicianReviewsFamily._allTransitiveDependencies,
          technicianId: technicianId,
        );

  TechnicianReviewsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.technicianId,
  }) : super.internal();

  final String technicianId;

  @override
  Override overrideWith(
    FutureOr<List<ReviewModel>> Function(TechnicianReviewsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TechnicianReviewsProvider._internal(
        (ref) => create(ref as TechnicianReviewsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        technicianId: technicianId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ReviewModel>> createElement() {
    return _TechnicianReviewsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TechnicianReviewsProvider &&
        other.technicianId == technicianId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, technicianId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TechnicianReviewsRef on AutoDisposeFutureProviderRef<List<ReviewModel>> {
  /// The parameter `technicianId` of this provider.
  String get technicianId;
}

class _TechnicianReviewsProviderElement
    extends AutoDisposeFutureProviderElement<List<ReviewModel>>
    with TechnicianReviewsRef {
  _TechnicianReviewsProviderElement(super.provider);

  @override
  String get technicianId => (origin as TechnicianReviewsProvider).technicianId;
}

String _$createBookingNotifierHash() =>
    r'1d30786019cda34b050a942b18c02a95465965ce';

/// See also [CreateBookingNotifier].
@ProviderFor(CreateBookingNotifier)
final createBookingNotifierProvider = AutoDisposeNotifierProvider<
    CreateBookingNotifier, AsyncValue<String?>>.internal(
  CreateBookingNotifier.new,
  name: r'createBookingNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createBookingNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreateBookingNotifier = AutoDisposeNotifier<AsyncValue<String?>>;
String _$bookingActionsNotifierHash() =>
    r'85676659d8fe4407e08076ed1197a985f22c65fa';

/// See also [BookingActionsNotifier].
@ProviderFor(BookingActionsNotifier)
final bookingActionsNotifierProvider = AutoDisposeNotifierProvider<
    BookingActionsNotifier, AsyncValue<void>>.internal(
  BookingActionsNotifier.new,
  name: r'bookingActionsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bookingActionsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BookingActionsNotifier = AutoDisposeNotifier<AsyncValue<void>>;
String _$reviewNotifierHash() => r'84cbcc338e9f2c41e1ea2a4d034740754749811a';

/// See also [ReviewNotifier].
@ProviderFor(ReviewNotifier)
final reviewNotifierProvider =
    AutoDisposeNotifierProvider<ReviewNotifier, AsyncValue<void>>.internal(
  ReviewNotifier.new,
  name: r'reviewNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reviewNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReviewNotifier = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
