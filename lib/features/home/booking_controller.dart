import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nishit_vadgama/core/constants/app_enums.dart';
import 'package:nishit_vadgama/core/helper/app_helper.dart';
import 'package:nishit_vadgama/core/services/booking_database_service.dart';
import 'package:nishit_vadgama/model/booking_model.dart';

/// Central reactive controller for all booking state.
/// Used by Dashboard, Booking List, and Detail screens via GetX dependency injection.
class BookingController extends GetxController {
  final BookingDatabaseService _db = BookingDatabaseService.to;

  final RxList<BookingModel> allBookings = <BookingModel>[].obs;
  final Rx<BookingFilterStatus> activeFilter = BookingFilterStatus.all.obs;
  final RxBool isLoading = false.obs;

  // ─── Derived Reactive Lists ───────────────────────────────────────────────

  List<BookingModel> get filteredBookings {
    final filter = activeFilter.value;
    if (filter == BookingFilterStatus.all) return allBookings;
    return allBookings.where((b) => b.status == filter.matchingStatus).toList();
  }

  List<BookingModel> get recentBookings => allBookings.take(3).toList();

  // ─── Stat Counts ─────────────────────────────────────────────────────────

  int get totalCount => allBookings.length;
  int get pendingCount =>
      allBookings.where((b) => b.status == BookingStatus.pending).length;
  int get confirmedCount =>
      allBookings.where((b) => b.status == BookingStatus.confirmed).length;
  int get completedCount =>
      allBookings.where((b) => b.status == BookingStatus.completed).length;
  int get cancelledCount =>
      allBookings.where((b) => b.status == BookingStatus.cancelled).length;

  @override
  void onInit() {
    super.onInit();
    loadBookings();
  }

  // ─── CRUD ─────────────────────────────────────────────────────────────────

  void loadBookings() {
    final data = _db.getAllBookings();
    allBookings.assignAll(data);
  }

  Future<void> addBooking(BookingModel booking) async {
    await _db.saveBooking(booking);
    loadBookings();
    AppHelper.showSuccessSnackbar(
      title: 'Booking Added',
      message: '${booking.customerName}\'s booking has been created.',
    );
  }

  Future<void> updateBookingStatus(String id, BookingStatus newStatus) async {
    final updated = await _db.updateStatus(id, newStatus);
    if (updated != null) {
      loadBookings();
      AppHelper.showSuccessSnackbar(
        title: 'Status Updated',
        message: 'Booking marked as ${newStatus.displayName}.',
      );
    }
  }

  Future<void> deleteBooking(String id, String customerName) async {
    final confirmed = await AppHelper.showConfirmDialog(
      title: 'Delete Booking',
      message:
          'Are you sure you want to delete $customerName\'s booking? This cannot be undone.',
      confirmText: 'Delete',
      confirmColor: const Color(0xFFc5221f),
    );
    if (confirmed == true) {
      await _db.deleteBooking(id);
      loadBookings();
      AppHelper.showSuccessSnackbar(
        title: 'Booking Deleted',
        message: 'The booking has been permanently removed.',
      );
    }
  }

  Future<void> cancelBooking(BookingModel booking) async {
    if (!booking.status.canCancel) return;
    final confirmed = await AppHelper.showConfirmDialog(
      title: 'Cancel Booking',
      message:
          'Cancel ${booking.customerName}\'s booking for ${booking.serviceName}?',
      confirmText: 'Yes, Cancel',
      confirmColor: const Color(0xFFc5221f),
    );
    if (confirmed == true) {
      await updateBookingStatus(booking.id, BookingStatus.cancelled);
    }
  }

  void setFilter(BookingFilterStatus filter) {
    activeFilter.value = filter;
  }

  BookingModel? findById(String id) {
    try {
      return allBookings.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }
}
