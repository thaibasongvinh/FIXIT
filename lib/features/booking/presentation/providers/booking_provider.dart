import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fixit/core/config/app_environment_provider.dart';
import 'package:fixit/core/config/appwrite_provider.dart';
import 'package:fixit/features/booking/data/appwrite_booking_repository_impl.dart';
import '../../../booking/domain/booking_repository.dart';
import '../../../booking/domain/models/booking_model.dart';
import '../../../booking/domain/models/review_model.dart';

part 'booking_provider.g.dart';

@riverpod
BookingRepository bookingRepository(Ref ref) {
  final db = ref.watch(appwriteDatabasesProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  final env = ref.watch(appEnvironmentProvider);
  return AppwriteBookingRepositoryImpl(
    databases: db,
    realtime: realtime,
    databaseId: env.appwriteDatabaseId,
  );
}

// Stream bookings của customer
@riverpod
Stream<List<BookingModel>> customerBookings(Ref ref, String customerId) =>
    ref.watch(bookingRepositoryProvider).watchCustomerBookings(customerId);

// Stream bookings của technician
@riverpod
Stream<List<BookingModel>> technicianBookings(Ref ref, String technicianId) {
  // MOCK DATA CHO BÁO CÁO - PHẦN VIỆC ĐANG CHẠY
  return Stream.value([
    BookingModel(
      id: 'mock_1',
      customerId: 'cust_1',
      customerName: 'Nguyễn Thị Lan',
      customerPhone: '0912345678',
      technicianId: technicianId,
      technicianName: 'Sng Ca',
      serviceType: 'Sửa Máy Giặt',
      deviceInfo: 'Samsung Inverter 9kg - Lỗi thoát nước',
      address: '123 Lê Lợi, Quận 1, TP.HCM',
      status: BookingStatus.accepted,
      estimatedPrice: 250000,
      scheduledAt: DateTime.now().add(const Duration(hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    BookingModel(
      id: 'mock_2',
      customerId: 'cust_2',
      customerName: 'Trần Văn Hùng',
      customerPhone: '0988777666',
      technicianId: technicianId,
      technicianName: 'Sng Ca',
      serviceType: 'Thay Vòi Nước',
      deviceInfo: 'Vòi sen nhà tắm rò rỉ nước',
      address: '456 Nguyễn Huệ, Quận 1, TP.HCM',
      status: BookingStatus.inProgress,
      estimatedPrice: 120000,
      scheduledAt: DateTime.now().add(const Duration(hours: 4)),
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ]);
  
  /* // Logic gốc (Khôi phục sau khi xong báo cáo)
  return ref.watch(bookingRepositoryProvider).watchTechnicianBookings(technicianId);
  */
}

// Realtime 1 booking
@riverpod
Stream<BookingModel?> bookingDetail(Ref ref, String bookingId) =>
    ref.watch(bookingRepositoryProvider).watchBookingById(bookingId);

// Tạo booking mới
@riverpod
class CreateBookingNotifier extends _$CreateBookingNotifier {
  @override
  AsyncValue<String?> build() => const AsyncData(null);

  Future<void> create(BookingModel booking) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(bookingRepositoryProvider).createBooking(booking));
  }
}

// Quản lý trạng thái booking (technician actions)
@riverpod
class BookingActionsNotifier extends _$BookingActionsNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> accept(String bookingId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(bookingRepositoryProvider).acceptBooking(bookingId));
  }

  Future<void> start(String bookingId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(bookingRepositoryProvider).startBooking(bookingId));
  }

  Future<void> complete(String bookingId, int finalPrice) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref
        .read(bookingRepositoryProvider)
        .completeBooking(bookingId, finalPrice));
  }

  Future<void> cancel(String bookingId, String reason) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(bookingRepositoryProvider).cancelBooking(bookingId, reason));
  }

  Future<void> pay(String bookingId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(bookingRepositoryProvider).payBooking(bookingId));
  }
}

// Submit review
@riverpod
class ReviewNotifier extends _$ReviewNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> submit(ReviewModel review) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(bookingRepositoryProvider).submitReview(review));
  }
}

@riverpod
Future<List<ReviewModel>> technicianReviews(Ref ref, String technicianId) async {
  // MOCK REVIEWS CHO BÁO CÁO
  if (technicianId.startsWith('tech_')) {
    return [
      ReviewModel(
        id: 'rev_1',
        bookingId: 'b_1',
        customerId: 'c_1',
        customerName: 'Hoàng Anh',
        technicianId: technicianId,
        rating: 5,
        content: 'Anh thợ rất nhiệt tình, sửa nhanh và sạch sẽ. Giá cả lại rất hợp lý nữa!',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ReviewModel(
        id: 'rev_2',
        bookingId: 'b_2',
        customerId: 'c_2',
        customerName: 'Minh Thư',
        technicianId: technicianId,
        rating: 4,
        content: 'Dịch vụ tốt, thợ đúng hẹn. Sẽ tiếp tục ủng hộ FixIt.',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  return ref.watch(bookingRepositoryProvider).getReviews(technicianId);
}
