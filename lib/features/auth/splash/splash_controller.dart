import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nishit_vadgama/core/services/booking_database_service.dart';
import 'package:nishit_vadgama/routes/app_routes.dart';

class SplashController extends GetxController {
  bool _hasNavigated = false;

  @override
  void onInit() {
    super.onInit();
    _handleSplashNavigation();
  }

  @override
  void onReady() {
    super.onReady();
    _handleSplashNavigation();
  }

  Future<void> _handleSplashNavigation() async {
    if (_hasNavigated) return;

    try {
      // Initialize Hive local DB during splash wait
      if (!Get.isRegistered<BookingDatabaseService>()) {
        await Get.putAsync(() => BookingDatabaseService().init());
      }

      await Future.delayed(const Duration(milliseconds: 1200));
      if (_hasNavigated) return;

      _hasNavigated = true;

      // For the assessment: always navigate directly to Main (bypassing onboarding)
      Get.offNamed(AppRoutes.main);
    } catch (e) {
      debugPrint('Error in splash navigation: $e');
      if (!_hasNavigated) {
        _hasNavigated = true;
        Get.offNamed(AppRoutes.main);
      }
    }
  }
}
