import 'package:flutter/material.dart';
import 'package:nishit_vadgama/core/constants/app_colors.dart';

enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled;

  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case BookingStatus.pending:
        return AppColors.orange;
      case BookingStatus.confirmed:
        return AppColors.primary;
      case BookingStatus.completed:
        return AppColors.success;
      case BookingStatus.cancelled:
        return AppColors.error;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case BookingStatus.pending:
        return const Color(0xFFFFF3E0);
      case BookingStatus.confirmed:
        return AppColors.primaryPastle;
      case BookingStatus.completed:
        return AppColors.successPastle;
      case BookingStatus.cancelled:
        return const Color(0xFFFFEBEE);
    }
  }

  IconData get icon {
    switch (this) {
      case BookingStatus.pending:
        return Icons.schedule_rounded;
      case BookingStatus.confirmed:
        return Icons.check_circle_outline_rounded;
      case BookingStatus.completed:
        return Icons.task_alt_rounded;
      case BookingStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  /// Whether this booking can be marked as Confirmed.
  bool get canConfirm => this == BookingStatus.pending;

  /// Whether this booking can be marked as Completed.
  bool get canComplete => this == BookingStatus.confirmed;

  /// Whether this booking is eligible for cancellation.
  bool get canCancel =>
      this == BookingStatus.pending || this == BookingStatus.confirmed;

  /// The next sequential progression status if any.
  BookingStatus? get nextStatus {
    switch (this) {
      case BookingStatus.pending:
        return BookingStatus.confirmed;
      case BookingStatus.confirmed:
        return BookingStatus.completed;
      case BookingStatus.completed:
      case BookingStatus.cancelled:
        return null;
    }
  }

  /// Helper to serialize safely from String
  static BookingStatus fromString(String? value) {
    if (value == null) return BookingStatus.pending;
    return BookingStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == value.trim().toLowerCase(),
      orElse: () => BookingStatus.pending,
    );
  }
}

/// Filter options for the Booking List view.
enum BookingFilterStatus {
  all,
  pending,
  confirmed,
  completed,
  cancelled;

  String get displayName {
    switch (this) {
      case BookingFilterStatus.all:
        return 'All';
      case BookingFilterStatus.pending:
        return 'Pending';
      case BookingFilterStatus.confirmed:
        return 'Confirmed';
      case BookingFilterStatus.completed:
        return 'Completed';
      case BookingFilterStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Matching [BookingStatus], or null if 'all'.
  BookingStatus? get matchingStatus {
    switch (this) {
      case BookingFilterStatus.all:
        return null;
      case BookingFilterStatus.pending:
        return BookingStatus.pending;
      case BookingFilterStatus.confirmed:
        return BookingStatus.confirmed;
      case BookingFilterStatus.completed:
        return BookingStatus.completed;
      case BookingFilterStatus.cancelled:
        return BookingStatus.cancelled;
    }
  }
}

/// Predefined service catalogue options for creating bookings.
enum PredefinedService {
  acService('AC Service', Icons.ac_unit_rounded),
  homeCleaning('Home Cleaning', Icons.cleaning_services_rounded),
  plumbing('Plumbing', Icons.plumbing_rounded),
  salonAppointment('Salon Appointment', Icons.content_cut_rounded),
  electricalRepair('Electrical Repair', Icons.electrical_services_rounded),
  painting('Painting', Icons.format_paint_rounded),
  carpentry('Carpentry', Icons.handyman_rounded);

  final String title;
  final IconData icon;

  const PredefinedService(this.title, this.icon);

  static List<String> get names =>
      PredefinedService.values.map((s) => s.title).toList();
}
