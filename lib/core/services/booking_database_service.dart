import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nishit_vadgama/core/constants/app_enums.dart';
import 'package:nishit_vadgama/core/constants/dummy_data.dart';
import 'package:nishit_vadgama/model/booking_model.dart';
import 'package:nishit_vadgama/model/booking_model_adapter.dart';

/// Local database service utilizing Hive for high-performance offline persistence.
///
/// Features:
/// - Fast binary serialization with [BookingModelAdapter]
/// - Automatic mock seeding on initial app launch (5 assessment bookings)
/// - Atomic CRUD operations with instant synchronous reads
/// - In-memory reactive integration with GetX
class BookingDatabaseService extends GetxService {
  static const String boxName = 'bookings_box';

  late Box<BookingModel> _box;

  /// Global accessor
  static BookingDatabaseService get to => Get.find<BookingDatabaseService>();

  /// Initialize Hive, register adapters, open box, and seed mock data if empty.
  Future<BookingDatabaseService> init() async {
    try {
      await Hive.initFlutter();

      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(BookingModelAdapter());
      }

      _box = await Hive.openBox<BookingModel>(boxName);

      // Seed initial mock data if this is the first run
      if (_box.isEmpty) {
        debugPrint('[BookingDatabaseService] Box is empty. Seeding initial mock data...');
        for (final booking in DummyData.initialBookings) {
          await _box.put(booking.id, booking);
        }
      }

      debugPrint('[BookingDatabaseService] Initialized with ${_box.length} records.');
    } catch (e, stack) {
      debugPrint('[BookingDatabaseService] Initialization error: $e\n$stack');
      rethrow;
    }
    return this;
  }

  // ---------------------------------------------------------------------------
  // READ OPERATIONS
  // ---------------------------------------------------------------------------

  /// Returns all bookings sorted by booking date ascending.
  List<BookingModel> getAllBookings() {
    final list = _box.values.toList();
    list.sort((a, b) => a.bookingDate.compareTo(b.bookingDate));
    return list;
  }

  /// Retrieve a single booking by its unique ID.
  BookingModel? getBookingById(String id) {
    return _box.get(id);
  }

  /// Returns total count of bookings in the local DB.
  int get count => _box.length;

  /// Returns count of bookings matching specific [BookingStatus].
  int countByStatus(BookingStatus status) {
    return _box.values.where((b) => b.status == status).length;
  }

  // ---------------------------------------------------------------------------
  // WRITE OPERATIONS
  // ---------------------------------------------------------------------------

  /// Adds a new booking or overwrites existing by ID.
  Future<void> saveBooking(BookingModel booking) async {
    await _box.put(booking.id, booking);
  }

  /// Updates status of an existing booking.
  Future<BookingModel?> updateStatus(String id, BookingStatus newStatus) async {
    final existing = _box.get(id);
    if (existing == null) return null;

    final updated = existing.copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
    );
    await _box.put(id, updated);
    return updated;
  }

  /// Cancels an existing booking.
  Future<BookingModel?> cancelBooking(String id) async {
    return await updateStatus(id, BookingStatus.cancelled);
  }

  /// Deletes a booking permanently from local storage.
  Future<void> deleteBooking(String id) async {
    await _box.delete(id);
  }

  /// Clears the box and resets back to the original 5 assessment mock bookings.
  Future<void> resetToMockData() async {
    await _box.clear();
    for (final booking in DummyData.initialBookings) {
      await _box.put(booking.id, booking);
    }
  }

  /// Clears all records.
  Future<void> clearAll() async {
    await _box.clear();
  }
}
