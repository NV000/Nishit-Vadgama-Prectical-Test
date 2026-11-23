import 'package:hive/hive.dart';
import 'package:nishit_vadgama/core/constants/app_enums.dart';
import 'package:nishit_vadgama/model/booking_model.dart';

/// Hive TypeAdapter for [BookingModel].
/// TypeId: 1
///
/// Hand-crafted adapter to eliminate dependency on build_runner code generation
/// while providing fast binary serialization and deserialization.
class BookingModelAdapter extends TypeAdapter<BookingModel> {
  @override
  final int typeId = 1;

  @override
  BookingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return BookingModel(
      id: fields[0] as String? ?? '',
      customerName: fields[1] as String? ?? '',
      phoneNumber: fields[2] as String? ?? '',
      serviceName: fields[3] as String? ?? '',
      bookingDate: fields[4] is int
          ? DateTime.fromMillisecondsSinceEpoch(fields[4] as int)
          : (fields[4] is String
              ? DateTime.tryParse(fields[4] as String) ?? DateTime.now()
              : DateTime.now()),
      status: BookingStatus.fromString(fields[5] as String?),
      notes: fields[6] as String?,
      createdAt: fields[7] is int
          ? DateTime.fromMillisecondsSinceEpoch(fields[7] as int)
          : (fields[7] is String
              ? DateTime.tryParse(fields[7] as String) ?? DateTime.now()
              : DateTime.now()),
      updatedAt: fields[8] == null
          ? null
          : (fields[8] is int
              ? DateTime.fromMillisecondsSinceEpoch(fields[8] as int)
              : DateTime.tryParse(fields[8].toString())),
    );
  }

  @override
  void write(BinaryWriter writer, BookingModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customerName)
      ..writeByte(2)
      ..write(obj.phoneNumber)
      ..writeByte(3)
      ..write(obj.serviceName)
      ..writeByte(4)
      ..write(obj.bookingDate.millisecondsSinceEpoch)
      ..writeByte(5)
      ..write(obj.status.name)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.createdAt.millisecondsSinceEpoch)
      ..writeByte(8)
      ..write(obj.updatedAt?.millisecondsSinceEpoch);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
