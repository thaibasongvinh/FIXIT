import 'models/booking_model.dart';
import 'models/review_model.dart';

abstract class BookingRepository {
  // Customer: tạo booking mới
  Future<String> createBooking(BookingModel booking);

  // Lấy booking của customer
  Stream<List<BookingModel>> watchCustomerBookings(String customerId);

  // Lấy booking của technician
  Stream<List<BookingModel>> watchTechnicianBookings(String technicianId,
      {BookingStatus? status});

  // Chi tiết 1 booking (realtime)
  Stream<BookingModel?> watchBookingById(String bookingId);

  // ── STATE MACHINE transitions ─────────────────────
  // Technician nhận đơn: pending → accepted
  Future<void> acceptBooking(String bookingId);

  // Technician bắt đầu sửa: accepted → in_progress
  Future<void> startBooking(String bookingId);

  // Technician hoàn thành: in_progress → done
  Future<void> completeBooking(String bookingId, int finalPrice);

  // Huỷ đơn: pending/accepted → cancelled
  Future<void> cancelBooking(String bookingId, String reason);

  // Thanh toán: pending → paid
  Future<void> payBooking(String bookingId);

  // Customer đánh giá sau done
  Future<void> submitReview(ReviewModel review);

  // Danh sách reviews của technician
  Future<List<ReviewModel>> getReviews(String technicianId);
}
