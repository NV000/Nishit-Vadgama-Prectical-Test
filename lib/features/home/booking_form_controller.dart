import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nishit_vadgama/core/helper/app_helper.dart';
import 'package:nishit_vadgama/model/booking_model.dart';

/// Controller for the Create/Edit Booking form.
class BookingFormController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final customerNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  final Rx<String?> selectedService = Rx<String?>(null);
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    customerNameCtrl.dispose();
    phoneCtrl.dispose();
    notesCtrl.dispose();
    super.onClose();
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await AppHelper.pickDate(
      context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) selectedDate.value = picked;
  }

  String? validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Customer name is required';
    if (v.trim().length < 2) return 'Enter a valid name';
    return null;
  }

  String? validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Phone number is required';
    if (v.trim().length < 10) return 'Enter a valid 10-digit phone number';
    return null;
  }

  String? validateService(String? v) {
    if (selectedService.value == null) return 'Please select a service';
    return null;
  }

  String? validateDate(DateTime? d) {
    if (d == null) return 'Please select a booking date';
    return null;
  }

  Future<void> submitBooking() async {
    // Trigger date validation too
    if (!formKey.currentState!.validate()) return;
    if (selectedDate.value == null) {
      AppHelper.showErrorSnackbar(
        title: 'Date Required',
        message: 'Please select a booking date.',
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 400)); // UX polish

    final booking = BookingModel.create(
      customerName: customerNameCtrl.text.trim(),
      phoneNumber: phoneCtrl.text.trim(),
      serviceName: selectedService.value!,
      bookingDate: selectedDate.value!,
      notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
    );

    // Return the model back to caller (BookingListController will add it)
    Get.back(result: booking);
    isLoading.value = false;
  }
}
