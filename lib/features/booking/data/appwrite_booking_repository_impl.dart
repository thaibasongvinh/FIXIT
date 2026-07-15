import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/cupertino.dart';
import '../../../core/constants/app_constants.dart';
import '../../wallet/domain/models/wallet_model.dart';
import '../domain/booking_repository.dart';
import '../domain/models/booking_model.dart';
import '../domain/models/review_model.dart';

class AppwriteBookingRepositoryImpl implements BookingRepository {
  AppwriteBookingRepositoryImpl({
    required Databases databases,
    required Realtime realtime,
    required String databaseId,
  })  : _db = databases,
        _realtime = realtime,
        _dbId = databaseId;

  final Databases _db;
  final Realtime _realtime;
  final String _dbId;
  static const _bookingsCollId = AppwriteConstants.bookingsCollectionId;
  static const _reviewsCollId = AppwriteConstants.reviewsCollectionId;
  static const _techsCollId = AppwriteConstants.techniciansCollectionId;
  static const _walletCollId = 'wallets';
  static const _transCollId = 'transactions';

  @override
  Future<String> createBooking(BookingModel booking) async {
    // Check customer balance before creating
    try {
      final walletDoc = await _db.getDocument(
        databaseId: _dbId,
        collectionId: _walletCollId,
        documentId: booking.customerId,
      );
      final balance = walletDoc.data['balance'] as int;
      if (balance < booking.estimatedPrice) {
        throw Exception('Số dư ví không đủ để đặt đơn hàng này.');
      }
    } catch (e) {
      if (e is AppwriteException && e.code == 404) {
        throw Exception('Bạn chưa có ví. Vui lòng nạp tiền trước.');
      }
      rethrow;
    }

    final doc = await _db.createDocument(
      databaseId: _dbId,
      collectionId: _bookingsCollId,
      documentId: ID.unique(),
      data: {
        'customerId': booking.customerId,
        'customerName': booking.customerName,
        'customerPhone': booking.customerPhone,
        'technicianId': booking.technicianId,
        'technicianName': booking.technicianName,
        'technicianPhone': booking.technicianPhone,
        'serviceType': booking.serviceType,
        'deviceInfo': booking.deviceInfo,
        'address': booking.address,
        'status': booking.status.appwriteValue,
        'paymentStatus': booking.paymentStatus.name,
        'isReviewed': booking.isReviewed,
        'estimatedPrice': booking.estimatedPrice,
        'finalPrice': booking.finalPrice,
        'notes': booking.notes,
        'cancelReason': booking.cancelReason,
        'scheduledAt': booking.scheduledAt?.toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      permissions: [
        Permission.read(Role.user(booking.customerId)),
        Permission.read(Role.user(booking.technicianId)),
        Permission.update(Role.user(booking.customerId)),
        Permission.update(Role.user(booking.technicianId)),
      ],
    );
    return doc.$id;
  }

  @override
  Stream<List<BookingModel>> watchCustomerBookings(String customerId) {
    return Stream.fromFuture(_db.listDocuments(
      databaseId: _dbId,
      collectionId: _bookingsCollId,
      queries: [
        Query.equal('customerId', customerId),
        Query.orderDesc('createdAt'),
      ],
    )).map((snap) {
      debugPrint('Appwrite: watchCustomerBookings found ${snap.documents.length} docs for customer $customerId');
      return snap.documents.map((d) => BookingModel.fromAppwrite(d)).toList();
    });
  }

  @override
  Stream<List<BookingModel>> watchTechnicianBookings(String technicianId,
      {BookingStatus? status}) {
    final queries = [
      Query.equal('technicianId', technicianId),
      Query.orderDesc('createdAt'),
    ];
    if (status != null) {
      queries.add(Query.equal('status', status.name));
    }

    return Stream.fromFuture(_db.listDocuments(
      databaseId: _dbId,
      collectionId: _bookingsCollId,
      queries: queries,
    )).map((snap) {
      debugPrint('Appwrite: watchTechnicianBookings found ${snap.documents.length} docs for technician $technicianId (status: $status)');
      return snap.documents.map((d) => BookingModel.fromAppwrite(d)).toList();
    }).handleError((e) {
      debugPrint('Appwrite: [ERROR] watchTechnicianBookings for $technicianId: $e');
      return <BookingModel>[];
    });
  }

  @override
  Stream<BookingModel?> watchBookingById(String bookingId) async* {
    // 1. Initial fetch
    try {
      final doc = await _db.getDocument(
        databaseId: _dbId,
        collectionId: _bookingsCollId,
        documentId: bookingId,
      );
      yield BookingModel.fromAppwrite(doc);
    } catch (e) {
      debugPrint('Appwrite: [ERROR] watchBookingById initial fetch: $e');
    }

    // 2. Realtime subscription
    final subscription = _realtime.subscribe([
      'databases.$_dbId.collections.$_bookingsCollId.documents.$bookingId'
    ]);

    await for (final event in subscription.stream) {
      if (event.payload.isNotEmpty) {
        yield BookingModel.fromAppwrite(models.Document.fromMap(event.payload));
      }
    }
  }

  @override
  Future<void> acceptBooking(String bookingId) async {
    await _db.updateDocument(
      databaseId: _dbId,
      collectionId: _bookingsCollId,
      documentId: bookingId,
      data: {
        'status': BookingStatus.accepted.appwriteValue,
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
    _createSystemNotification(
      bookingId: bookingId,
      title: 'Đơn hàng đã được nhận',
      message: 'Thợ đã chấp nhận yêu cầu sửa chữa của bạn.',
      type: 'booking_accepted',
    );
  }

  @override
  Future<void> startBooking(String bookingId) async {
    await _db.updateDocument(
      databaseId: _dbId,
      collectionId: _bookingsCollId,
      documentId: bookingId,
      data: {
        'status': BookingStatus.inProgress.appwriteValue,
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
    _createSystemNotification(
      bookingId: bookingId,
      title: 'Thợ đang tiến hành sửa',
      message: 'Công việc sửa chữa đã được bắt đầu.',
      type: 'booking_started',
    );
  }

  @override
  Future<void> completeBooking(String bookingId, int finalPrice) async {
    // 1. Fetch booking details to get customer/technician IDs
    final doc = await _db.getDocument(
      databaseId: _dbId,
      collectionId: _bookingsCollId,
      documentId: bookingId,
    );
    final booking = BookingModel.fromAppwrite(doc);

    // 2. Perform Escrow Payment
    // In a real app, this should be an Appwrite Function for atomicity.
    // Here we implement it as sequential DB updates for simplicity.
    try {
      // A. Subtract from Customer
      final customerWallet = await _db.getDocument(
        databaseId: _dbId,
        collectionId: _walletCollId,
        documentId: booking.customerId,
      );
      final newCustomerBalance = (customerWallet.data['balance'] as int) - finalPrice;
      await _db.updateDocument(
        databaseId: _dbId,
        collectionId: _walletCollId,
        documentId: booking.customerId,
        data: {'balance': newCustomerBalance, 'updatedAt': DateTime.now().toIso8601String()},
      );

      // B. Add to Technician
      try {
        final techWallet = await _db.getDocument(
          databaseId: _dbId,
          collectionId: _walletCollId,
          documentId: booking.technicianId,
        );
        final newTechBalance = (techWallet.data['balance'] as int) + finalPrice;
        final newTotalEarned = (techWallet.data['totalEarned'] as num).toDouble() + finalPrice;
        await _db.updateDocument(
          databaseId: _dbId,
          collectionId: _walletCollId,
          documentId: booking.technicianId,
          data: {
            'balance': newTechBalance,
            'totalEarned': newTotalEarned,
            'updatedAt': DateTime.now().toIso8601String()
          },
        );
      } catch (e) {
        // If tech doesn't have a wallet, create one
        await _db.createDocument(
          databaseId: _dbId,
          collectionId: _walletCollId,
          documentId: booking.technicianId,
          data: {
            'userId': booking.technicianId,
            'balance': finalPrice,
            'totalEarned': finalPrice.toDouble(),
            'updatedAt': DateTime.now().toIso8601String()
          },
        );
      }

      // C. Create Transaction Records
      await _db.createDocument(
        databaseId: _dbId,
        collectionId: _transCollId,
        documentId: ID.unique(),
        data: {
          'walletId': booking.customerId,
          'userId': booking.customerId,
          'amount': -finalPrice,
          'type': 'payment',
          'status': 'success',
          'description': 'Thanh toán đơn hàng #${bookingId.substring(0, 5)}',
          'bookingId': bookingId,
          'createdAt': DateTime.now().toIso8601String(),
        }
      );

      await _db.createDocument(
        databaseId: _dbId,
        collectionId: _transCollId,
        documentId: ID.unique(),
        data: {
          'walletId': booking.technicianId,
          'userId': booking.technicianId,
          'amount': finalPrice,
          'type': 'payment',
          'status': 'success',
          'description': 'Nhận tiền đơn hàng #${bookingId.substring(0, 5)}',
          'bookingId': bookingId,
          'createdAt': DateTime.now().toIso8601String(),
        }
      );

      // 3. Update Booking Status
      await _db.updateDocument(
        databaseId: _dbId,
        collectionId: _bookingsCollId,
        documentId: bookingId,
        data: {
          'status': BookingStatus.completed.appwriteValue,
          'finalPrice': finalPrice,
          'paymentStatus': 'paid',
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );
      _createSystemNotification(
        bookingId: bookingId,
        title: 'Công việc hoàn thành',
        message: 'Thợ đã sửa xong! Vui lòng đánh giá dịch vụ.',
        type: 'booking_completed',
      );
    } catch (e) {
      debugPrint('Appwrite: [ERROR] completeBooking Escrow failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> cancelBooking(String bookingId, String reason) async {
    await _db.updateDocument(
      databaseId: _dbId,
      collectionId: _bookingsCollId,
      documentId: bookingId,
      data: {
        'status': BookingStatus.cancelled.appwriteValue,
        'cancelReason': reason,
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  Future<void> payBooking(String bookingId) async {
    await _db.updateDocument(
      databaseId: _dbId,
      collectionId: _bookingsCollId,
      documentId: bookingId,
      data: {
        'paymentStatus': 'paid',
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  Future<void> submitReview(ReviewModel review) async {
    // 1. Lưu review
    await _db.createDocument(
      databaseId: _dbId,
      collectionId: _reviewsCollId,
      documentId: ID.unique(),
      data: {
        'bookingId': review.bookingId,
        'customerId': review.customerId,
        'customerName': review.customerName,
        'technicianId': review.technicianId,
        'rating': review.rating,
        'content': review.content,
        'photos': review.photos,
        'createdAt': DateTime.now().toIso8601String(),
      },
      permissions: [
        Permission.read(Role.any()), // Review công khai
        Permission.update(Role.user(review.customerId)),
      ],
    );
    
    // 2. Cập nhật trạng thái Booking
    await _db.updateDocument(
      databaseId: _dbId,
      collectionId: _bookingsCollId,
      documentId: review.bookingId,
      data: {'isReviewed': true},
    );

    // 3. Tính toán lại rating của thợ sửa
    _updateTechnicianRating(review.technicianId);
  }

  Future<void> _updateTechnicianRating(String techId) async {
    try {
      final reviews = await getReviews(techId);
      if (reviews.isEmpty) return;

      final double avg = reviews.fold(0.0, (sum, item) => sum + item.rating) / reviews.length;
      
      await _db.updateDocument(
        databaseId: _dbId,
        collectionId: _techsCollId,
        documentId: techId,
        data: {
          'rating': double.parse(avg.toStringAsFixed(1)),
          'reviewCount': reviews.length,
        },
      );
    } catch (e) {
      // ignore
    }
  }

  @override
  Future<List<ReviewModel>> getReviews(String technicianId) async {
    final snap = await _db.listDocuments(
      databaseId: _dbId,
      collectionId: _reviewsCollId,
      queries: [
        Query.equal('technicianId', technicianId),
        Query.orderDesc('createdAt'),
        Query.limit(50),
      ],
    );
    return snap.documents.map((d) => ReviewModel.fromJson(d.data)).toList();
  }

  Future<void> _createSystemNotification({
    required String bookingId,
    required String title,
    required String message,
    required String type,
  }) async {
    try {
      final doc = await _db.getDocument(
        databaseId: _dbId,
        collectionId: _bookingsCollId,
        documentId: bookingId,
      );
      final booking = BookingModel.fromAppwrite(doc);

      await _db.createDocument(
        databaseId: _dbId,
        collectionId: 'notifications',
        documentId: ID.unique(),
        data: {
          'userId': booking.customerId,
          'title': title,
          'message': message,
          'type': type,
          'relatedId': bookingId,
          'isRead': false,
          'createdAt': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      debugPrint('Appwrite: Error creating notification: $e');
    }
  }
}
