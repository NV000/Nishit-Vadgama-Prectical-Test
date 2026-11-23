import 'package:get/get.dart';
import 'package:nishit_vadgama/features/home/booking_controller.dart';
import 'package:nishit_vadgama/features/home/main_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController(), fenix: true);
    Get.lazyPut<BookingController>(() => BookingController(), fenix: true);
  }
}
