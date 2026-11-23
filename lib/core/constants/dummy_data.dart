import 'package:nishit_vadgama/core/constants/app_enums.dart';
import 'package:nishit_vadgama/model/booking_model.dart';

class DummyData {
  DummyData._();

  static List<BookingModel> get initialBookings => [
    BookingModel(
      id: 'BK-1001',
      customerName: 'Aarav Shah',
      phoneNumber: '9876543210',
      serviceName: 'AC Service',
      bookingDate: DateTime(2026, 11, 26, 10, 30),
      status: BookingStatus.pending,
      notes: 'Master bedroom AC cooling issue and general filter servicing.',
      createdAt: DateTime(2026, 11, 20, 9, 15),
    ),
    BookingModel(
      id: 'BK-1002',
      customerName: 'Meera Patel',
      phoneNumber: '9823456781',
      serviceName: 'Home Cleaning',
      bookingDate: DateTime(2026, 11, 27, 14, 0),
      status: BookingStatus.confirmed,
      notes: 'Deep cleaning for 3BHK apartment before family gathering.',
      createdAt: DateTime(2026, 11, 21, 11, 45),
    ),
    BookingModel(
      id: 'BK-1003',
      customerName: 'Rohan Joshi',
      phoneNumber: '9712345678',
      serviceName: 'Plumbing',
      bookingDate: DateTime(2026, 11, 28, 16, 30),
      status: BookingStatus.completed,
      notes:
          'Kitchen sink pipe blockage replacement. Work inspected and tested.',
      createdAt: DateTime(2026, 11, 22, 13, 0),
    ),
    BookingModel(
      id: 'BK-1004',
      customerName: 'Diya Mehta',
      phoneNumber: '9901234567',
      serviceName: 'Salon Appointment',
      bookingDate: DateTime(2026, 11, 29, 11, 0),
      status: BookingStatus.cancelled,
      notes: 'Client rescheduled due to emergency travel.',
      createdAt: DateTime(2026, 11, 22, 15, 30),
    ),
    BookingModel(
      id: 'BK-1005',
      customerName: 'Kabir Desai',
      phoneNumber: '9898765432',
      serviceName: 'Electrical Repair',
      bookingDate: DateTime(2026, 11, 30, 15, 0),
      status: BookingStatus.pending,
      notes: 'Living room chandelier wiring and MCB tripping inspection.',
      createdAt: DateTime(2026, 11, 23, 10, 0),
    ),
  ];
}
