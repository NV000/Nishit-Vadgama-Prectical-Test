import 'package:nishit_vadgama/core/constants/app_enums.dart';

/// Model representing a service booking record.
/// Includes support for JSON serialization and Hive persistence.
class BookingModel {
  final String id;
  final String customerName;
  final String phoneNumber;
  final String serviceName;
  final DateTime bookingDate;
  final BookingStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const BookingModel({
    required this.id,
    required this.customerName,
    required this.phoneNumber,
    required this.serviceName,
    required this.bookingDate,
    this.status = BookingStatus.pending,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  /// Factory constructor to create a brand new booking.
  factory BookingModel.create({
    required String customerName,
    required String phoneNumber,
    required String serviceName,
    required DateTime bookingDate,
    BookingStatus status = BookingStatus.pending,
    String? notes,
  }) {
    final now = DateTime.now();
    final uniqueId = 'BK-${now.millisecondsSinceEpoch.toString().substring(7)}';
    return BookingModel(
      id: uniqueId,
      customerName: customerName.trim(),
      phoneNumber: phoneNumber.trim(),
      serviceName: serviceName.trim(),
      bookingDate: bookingDate,
      status: status,
      notes: (notes != null && notes.trim().isNotEmpty) ? notes.trim() : null,
      createdAt: now,
      updatedAt: null,
    );
  }

  /// Creates a copy with modified values.
  BookingModel copyWith({
    String? id,
    String? customerName,
    String? phoneNumber,
    String? serviceName,
    DateTime? bookingDate,
    BookingStatus? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      serviceName: serviceName ?? this.serviceName,
      bookingDate: bookingDate ?? this.bookingDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert to Map for serialization or storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'serviceName': serviceName,
      'bookingDate': bookingDate.toIso8601String(),
      'status': status.name,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Construct from Map.
  factory BookingModel.fromMap(Map<dynamic, dynamic> map) {
    return BookingModel(
      id: map['id'] as String? ?? '',
      customerName: map['customerName'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
      serviceName: map['serviceName'] as String? ?? '',
      bookingDate: map['bookingDate'] != null
          ? DateTime.tryParse(map['bookingDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
      status: BookingStatus.fromString(map['status']?.toString()),
      notes: map['notes'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          customerName == other.customerName &&
          phoneNumber == other.phoneNumber &&
          serviceName == other.serviceName &&
          bookingDate == other.bookingDate &&
          status == other.status &&
          notes == other.notes;

  @override
  int get hashCode =>
      id.hashCode ^
      customerName.hashCode ^
      phoneNumber.hashCode ^
      serviceName.hashCode ^
      bookingDate.hashCode ^
      status.hashCode ^
      notes.hashCode;

  @override
  String toString() {
    return 'BookingModel(id: $id, customer: $customerName, service: $serviceName, status: ${status.name}, date: $bookingDate)';
  }
}
